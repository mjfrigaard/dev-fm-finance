def co_box(
    color="b",
    header="header",
    contents="Your text",
    size="0.95",
    hsize="1.05",
    fold=False,
    look="default",
):
    """
    Render a Quarto callout box as raw markdown.

    Parameters
    ----------
    color : str
        One of 'b' (note), 'g' (tip), 'r' (important),
        'o' (warning), 'y' (caution).
    header : str
        Title text for the callout.
    contents : str
        Body text (markdown allowed).
    size : str or float
        Font size (em) for the body.
    hsize : str or float
        Font size (em) for the header.
    fold : bool
        Whether the callout starts collapsed.
    look : str
        One of 'default', 'simple', 'minimal'.
    """
    # Validate `look`
    if look not in ("default", "simple", "minimal"):
        look = "default"

    # Map color > callout class
    class_map = {
        "b": "note",
        "g": "tip",
        "r": "important",
        "o": "warning",
        "y": "caution",
    }
    if color not in class_map:
        raise ValueError("Invalid `color`. Use one of: b, g, r, o, y.")
    callout_class = class_map[color]

    # Normalize values to strings (lowercase booleans)
    fold_str = str(fold).lower()
    size = str(size)
    hsize = str(hsize)

    output = (
        f"\n\n"
        f":::: {{.callout-{callout_class} collapse='{fold_str}'"
        f" appearance='{look}' icon=false}}\n\n"
        f"## [{header}]{{style='font-weight: bold; "
        f"font-size: {hsize}em;'}}\n\n"
        f"::: {{style='font-size: {size}em; color: #282b2d;'}}\n\n"
        f"\n{contents}\n\n"
        f"::: \n\n"
        f"::::\n"
    )

    print(output)
