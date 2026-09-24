#!/usr/bin/env python3
"""Generate per-map "table position" sidecars for the stands feature.

Each stands area map (Pais/Court/DaVinci/Cinematheque/PopUp) is an SVG in
Assets.xcassets/Stands/<Map>.imageset/. Every table is drawn as a small
square (a <rect fill="#E1D1EB">) immediately followed by a <path> that
outlines its label (e.g. "ש1") as a filled glyph shape -- there's no <text>
and no useful id/name on either element.

This script locates every table rect in each map (see _extract_rects.py)
and figures out which table ID belongs to which rect, then writes one JSON
sidecar per map into the asset catalog as a Data Set, e.g.
Assets.xcassets/Stands/PaisTables.dataset/tables.json, so the app can look
up a stand's table rects at runtime via NSDataAsset(name: "PaisTables").

The ID assignment for each map was worked out by hand (rendering each map,
and zoomed/annotated crops of it, and reading the actual labels) since the
labels are vector glyph outlines, not text, and this Mac's Vision OCR has no
Hebrew. What's encoded below is the *result* of that reading -- the actual
row/column layout of each map's tables -- expressed as small position-based
or index-based rules. If a map's SVG is redrawn for a future edition, this
script's per-map logic needs to be re-derived by re-reading the new map the
same way; the rule tables here won't automatically still be correct.

Every result is validated against the actual table IDs referenced in
cache/icon2026Stands.json before anything is written, and a debug SVG (with
the decoded ID drawn in red next to each rect) is written to the scratchpad
for a final by-eye sanity check against the real map.
"""
import json
import os
import re
import xml.etree.ElementTree as ET

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
STANDS_DIR = os.path.join(REPO_ROOT, "Conventions/Conventions/Assets.xcassets/Stands")
CACHE_JSON = os.path.join(REPO_ROOT, "Conventions/Conventions/cache/icon2026Stands.json")
DEBUG_DIR = "/tmp/stand_table_debug"

SVG_NS = "{http://www.w3.org/2000/svg}"
TABLE_FILL = "#e1d1eb"


def _parse_translate(transform):
    """Returns (tx, ty), or None if `transform` is something other than a plain
    translate() (e.g. a rotated/scaled decorative icon elsewhere in the file --
    table rects are only ever wrapped in translate()s in these maps)."""
    if not transform:
        return (0.0, 0.0)
    m = re.match(r"\s*translate\(\s*([-\d.eE]+)\s*[, ]?\s*([-\d.eE]*)\s*\)\s*$", transform)
    if not m:
        return None
    tx = float(m.group(1))
    ty = float(m.group(2)) if m.group(2) else 0.0
    return (tx, ty)


def _walk(el, ox, oy, out):
    t = _parse_translate(el.get("transform"))
    if t is None:
        return  # unsupported transform -- not a table subtree, don't descend
    cx, cy = ox + t[0], oy + t[1]
    if el.tag.replace(SVG_NS, "") == "rect" and (el.get("fill") or "").lower() == TABLE_FILL:
        w = float(el.get("width"))
        h = float(el.get("height"))
        x = cx + float(el.get("x") or 0)
        y = cy + float(el.get("y") or 0)
        if w < 150 and h < 150 and abs(w - h) <= max(w, h) * 0.15:  # a table, not some other shape
            out.append({"x": x, "y": y, "w": w, "h": h})
    for child in el:
        _walk(child, cx, cy, out)


def extract(svg_path):
    """Every table rect (small square, fill #E1D1EB) in a stands map SVG, resolving
    nested <g transform="translate(...)"> ancestors into absolute image-space
    coordinates, in SVG document order."""
    out = []
    _walk(ET.parse(svg_path).getroot(), 0.0, 0.0, out)
    return out


def rows_of(rects, y_tol=10):
    """Group rects into rows by y, each row sorted left-to-right by x."""
    remaining = sorted(rects, key=lambda r: r["y"])
    rows = []
    for r in remaining:
        row = next((row for row in rows if abs(row[0]["y"] - r["y"]) <= y_tol), None)
        if row is None:
            rows.append([r])
        else:
            row.append(r)
    for row in rows:
        row.sort(key=lambda r: r["x"])
    rows.sort(key=lambda row: row[0]["y"])
    return rows


def pais_ids(rects):
    rows = rows_of(rects)
    assert [len(r) for r in rows] == [8, 2], f"unexpected Pais layout: {[len(r) for r in rows]}"
    top, bottom = rows
    out = {}
    for i, r in enumerate(top):
        out[f"ש{i + 2}"] = r  # top row: ש2..ש9, ascending
    out["ש1"] = bottom[0]
    out["ש10"] = bottom[1]
    return out


def davinci_ids(rects):
    rows = rows_of(rects)
    assert [len(r) for r in rows] == [12], f"unexpected DaVinci layout: {[len(r) for r in rows]}"
    return {f"ח{i + 1}": r for i, r in enumerate(rows[0])}


def cinematheque_ids(rects):
    rows = rows_of(rects)
    assert [len(r) for r in rows] == [4, 2], f"unexpected Cinematheque layout: {[len(r) for r in rows]}"
    top, bottom = rows
    out = {f"ס{i + 3}": r for i, r in enumerate(top)}  # top row: ס3..ס6
    out["ס1"] = bottom[0]
    out["ס2"] = bottom[1]
    return out


def popup_ids(rects):
    rows = rows_of(rects)
    assert [len(r) for r in rows] == [12], f"unexpected PopUp layout: {[len(r) for r in rows]}"
    return {f"פ{i + 1}": r for i, r in enumerate(rows[0])}


def court_ids(rects):
    """Court (מגרש) has 246 table rects for letters א-ז (245 assigned table
    IDs + 1 spare/unused table). Rects are taken in SVG document order
    (index below), grouped into the physical row/column blocks that make up
    each letter's run of tables (see the module docstring)."""
    n = len(rects)
    assert n == 246, f"unexpected Court rect count: {n}"
    out = {}

    def put(letter, idx, num):
        out[f"{letter}{num}"] = rects[idx]

    # א: single row, ascending, idx 34..65 -> 1..32
    for idx in range(34, 66):
        put("א", idx, idx - 33)

    # ד: single row, ascending, idx 0..33 -> 1..34
    for idx in range(0, 34):
        put("ד", idx, idx + 1)

    # ב: top row idx130..145 -> 1..16 ascending; vertical connector
    # idx164..167 -> 17..20; bottom row idx146..163 -> 38..21 descending.
    for idx in range(130, 146):
        put("ב", idx, idx - 129)
    for idx in range(164, 168):
        put("ב", idx, idx - 147)
    for idx in range(146, 164):
        put("ב", idx, 184 - idx)

    # ג: top row idx72..81 -> 10..1 descending; vertical connector
    # idx168..171 -> 11..14; bottom row idx82..91 -> 15..24 ascending.
    for idx in range(72, 82):
        put("ג", idx, 82 - idx)
    for idx in range(168, 172):
        put("ג", idx, idx - 157)
    for idx in range(82, 92):
        put("ג", idx, idx - 67)

    # ו: single row, ascending, idx 92..129 -> 1..38
    for idx in range(92, 130):
        put("ו", idx, idx - 91)

    # ה: several disjoint runs on the right side of the map.
    for idx in (66, 67):
        put("ה", idx, idx - 65)  # 1..2
    for idx in range(68, 72):
        put("ה", idx, idx - 65)  # 3..6
    for idx in range(230, 238):
        put("ה", idx, idx - 223)  # 7..14
    for idx in range(226, 230):
        put("ה", idx, idx - 211)  # 15..18
    for idx in range(238, 244):
        put("ה", idx, 262 - idx)  # 19..24 (238->24 .. 243->19)
    for idx in range(172, 184):
        put("ה", idx, 210 - idx)  # 172->38 .. 183->27
    for idx in (244, 245):
        put("ה", idx, 270 - idx)  # 244->26, 245->25

    # ז: tall column on the far right edge, idx 184..225 -> 42..1
    # descending (226 - idx), with idx 187 (-> 39) an unassigned spare table
    # that has no matching stand this year -- still recorded.
    for idx in range(184, 226):
        put("ז", idx, 226 - idx)

    assert len(out) == 246, f"expected 246 decoded Court tables, got {len(out)}"
    return out


MAPS = {
    "Pais": pais_ids,
    "DaVinci": davinci_ids,
    "Cinematheque": cinematheque_ids,
    "PopUp": popup_ids,
    "Court": court_ids,
}

SVG_FILES = {
    "Pais": "Pais.imageset/pais.svg",
    "DaVinci": "DaVinci.imageset/davinci.svg",
    "Cinematheque": "Cinematheque.imageset/Artist Alley - Cinematheque.svg",
    "PopUp": "PopUp.imageset/popup.svg",
    "Court": "Court.imageset/court.svg",
}

AREA_TITLE_FOR_MAP = {
    "Pais": "אשכול",
    "DaVinci": "דה וינצ'י",
    "Cinematheque": "סינמטק",
    "PopUp": "פופ-אפ",
    "Court": "מגרש",
}


def referenced_ids(area_title):
    data = json.load(open(CACHE_JSON, encoding="utf-8"))
    ids = set()
    for stand in data:
        if (stand.get("area") or {}).get("title") != area_title:
            continue
        for t in (stand.get("tableIds") or {}).get("list") or []:
            ids.add(t)
    return ids


def write_debug_svg(map_name, svg_path, id_to_rect):
    os.makedirs(DEBUG_DIR, exist_ok=True)
    s = open(svg_path, encoding="utf-8").read()
    texts = []
    for table_id, r in id_to_rect.items():
        cx = r["x"] + r["w"] / 2
        ty = r["y"] - r["h"] * 0.28
        fs = max(r["w"] * 0.3, 16)
        texts.append(
            f'<text x="{cx}" y="{ty}" font-size="{fs}" fill="red" font-weight="bold" '
            f'text-anchor="middle" font-family="Helvetica">{table_id}</text>'
        )
    out = re.sub(r"</svg>\s*$", "\n".join(texts) + "\n</svg>", s.rstrip())
    out_path = os.path.join(DEBUG_DIR, f"{map_name}_debug.svg")
    open(out_path, "w", encoding="utf-8").write(out)
    return out_path


def main():
    for map_name, id_fn in MAPS.items():
        svg_path = os.path.join(STANDS_DIR, SVG_FILES[map_name])
        rects = extract(svg_path)
        id_to_rect = id_fn(rects)

        expected = referenced_ids(AREA_TITLE_FOR_MAP[map_name])
        missing = expected - id_to_rect.keys()
        if missing:
            raise SystemExit(f"{map_name}: table IDs referenced by stands but not decoded: {sorted(missing)}")

        table_positions = {
            table_id: [round(r["x"], 2), round(r["y"], 2), round(r["w"], 2), round(r["h"], 2)]
            for table_id, r in id_to_rect.items()
        }

        dataset_dir = os.path.join(STANDS_DIR, f"{map_name}Tables.dataset")
        os.makedirs(dataset_dir, exist_ok=True)
        json.dump(
            table_positions,
            open(os.path.join(dataset_dir, "tables.json"), "w", encoding="utf-8"),
            ensure_ascii=False,
            indent=2,
            sort_keys=True,
        )
        contents = {
            "data": [{"filename": "tables.json", "idiom": "universal"}],
            "info": {"author": "xcode", "version": 1},
        }
        json.dump(
            contents,
            open(os.path.join(dataset_dir, "Contents.json"), "w", encoding="utf-8"),
            indent=2,
        )

        debug_path = write_debug_svg(map_name, svg_path, id_to_rect)
        print(f"{map_name}: {len(id_to_rect)} tables decoded, {len(expected)} referenced by stands -- OK")
        print(f"  wrote {dataset_dir}")
        print(f"  debug: {debug_path}")


if __name__ == "__main__":
    main()
