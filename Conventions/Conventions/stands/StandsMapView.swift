//
//  StandsMapView.swift
//  Conventions
//

import SwiftUI
import UIKit

struct StandsMapView: View {
    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .ignoresSafeArea()

            ZoomableImageView(image: UIImage(named: "Overview"))
                .ignoresSafeArea()
        }
    }
}

// Wraps the existing UIScrollView-based zoom/double-tap-to-zoom pattern (also used by
// MapFloorViewController) rather than reimplementing zoom/pan gesture math natively in SwiftUI.
private struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage?

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        context.coordinator.imageView = imageView

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        var imageView: UIImageView?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
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

#Preview {
    StandsMapView()
}
