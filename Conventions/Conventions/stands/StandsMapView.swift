//
//  StandsMapView.swift
//  Conventions
//

import SwiftUI
import UIKit
import AVFoundation

struct StandsMapView: View {
    let mapImageName: String
    var highlightedRects: [CGRect] = []
    var maximumZoomScale: CGFloat = 3

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ZoomableImageView(image: UIImage(named: mapImageName), highlightedRects: highlightedRects, maximumZoomScale: maximumZoomScale)
                .ignoresSafeArea()
        }
    }
}

// Wraps the existing UIScrollView-based zoom/double-tap-to-zoom pattern (also used by
// MapFloorViewController) rather than reimplementing zoom/pan gesture math natively in SwiftUI.
// Also reused by StandsListView for its inline map preview.
struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage?
    // A stand's table rects to highlight and zoom to, in the map image's own point
    // coordinates (see StandArea.tableRects(for:)). Empty clears the highlight and
    // leaves the current zoom/pan alone.
    var highlightedRects: [CGRect] = []
    // Per-area cap (see StandArea.maximumZoomScale) -- respected both for pinch/double-tap
    // zoom and for the zoom-to-highlighted-tables below, which never zooms in past it.
    var maximumZoomScale: CGFloat = 3

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = maximumZoomScale

        let containerView = HighlightingImageContainerView()
        containerView.imageView.image = image
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        context.coordinator.containerView = containerView

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.maximumZoomScale = maximumZoomScale
        context.coordinator.apply(highlightedRects: highlightedRects, in: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        var containerView: HighlightingImageContainerView?
        private var lastAppliedRects: [CGRect] = []

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return containerView
        }

        func apply(highlightedRects: [CGRect], in scrollView: UIScrollView) {
            guard let containerView, highlightedRects != lastAppliedRects else { return }
            lastAppliedRects = highlightedRects
            containerView.highlightedRects = highlightedRects

            guard !highlightedRects.isEmpty else { return }
            zoom(to: highlightedRects, in: scrollView, containerView: containerView)
        }

        private func zoom(to rects: [CGRect], in scrollView: UIScrollView, containerView: HighlightingImageContainerView) {
            // The scroll view may not have its final bounds yet (e.g. right after this
            // screen/the fullscreen map appears), so wait a beat for layout to settle.
            guard scrollView.bounds.width > 0, scrollView.bounds.height > 0 else {
                DispatchQueue.main.async { [weak self] in
                    scrollView.layoutIfNeeded()
                    self?.zoom(to: rects, in: scrollView, containerView: containerView)
                }
                return
            }
            guard let contentRect = containerView.contentSpaceRect(forImageRects: rects) else { return }

            let averageTableSize = (contentRect.width + contentRect.height) / CGFloat(max(rects.count, 1)) / 2
            let padding = max(averageTableSize * 1.5, 24)
            let paddedRect = contentRect.insetBy(dx: -padding, dy: -padding)

            // zoom(to:animated:) clamps to the scroll view's current maximumZoomScale on its
            // own (staying centered on paddedRect) if that rect would need more than it allows.
            scrollView.zoom(to: paddedRect, animated: true)
        }

        @objc func mapWasDoubleTapped(_ sender: UITapGestureRecognizer) {
            guard let scrollView = sender.view as? UIScrollView else { return }

            // In case the current zoom scale is lower then the max, scale it to max on double tap
            let scale = scrollView.zoomScale == scrollView.maximumZoomScale
                ? scrollView.minimumZoomScale
                : scrollView.maximumZoomScale;

            scrollView.zoomToPoint(sender.location(in: scrollView), withScale: scale, animated: true);
        }
    }
}

// Hosts the map UIImageView plus a highlight overlay for a stand's tables, drawn as a
// sibling CAShapeLayer so it pans/zooms together with the image (this view is what
// ZoomableImageView.Coordinator returns from viewForZooming(in:)).
final class HighlightingImageContainerView: UIView {
    let imageView = UIImageView()
    private let highlightLayer = CAShapeLayer()

    var highlightedRects: [CGRect] = [] {
        didSet { setNeedsLayout() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        highlightLayer.fillColor = Colors.standTableHighlightColor.withAlphaComponent(0.5).cgColor
        layer.addSublayer(highlightLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateHighlightPath()
    }

    /// Maps this stand's rects (in the map image's own point coordinates) into this
    /// view's own bounds coordinate space -- i.e. the same coordinate space
    /// UIScrollView.zoom(to:animated:) expects for the view returned by
    /// viewForZooming(in:), regardless of the scroll view's current zoom scale.
    func contentSpaceRect(forImageRects rects: [CGRect]) -> CGRect? {
        mappedToContentSpace(rects)?.reduce(CGRect.null) { $0.union($1) }
    }

    private func mappedToContentSpace(_ rects: [CGRect]) -> [CGRect]? {
        guard let image = imageView.image, !rects.isEmpty, bounds.width > 0, bounds.height > 0 else { return nil }
        let fitRect = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
        let scale = fitRect.width / image.size.width
        return rects.map {
            CGRect(x: fitRect.minX + $0.minX * scale, y: fitRect.minY + $0.minY * scale, width: $0.width * scale, height: $0.height * scale)
        }
    }

    private func updateHighlightPath() {
        guard let scaledRects = mappedToContentSpace(highlightedRects) else {
            highlightLayer.path = nil
            return
        }
        let path = UIBezierPath()
        for scaledRect in scaledRects {
            path.append(UIBezierPath(rect: scaledRect))
        }
        highlightLayer.path = path.cgPath
    }
}

#Preview {
    StandsMapView(mapImageName: "Overview")
}
