import from "clsx" { clsx }
import from "tailwind-merge" { twMerge }

def:pub cn(
    a: any = None,
    b: any = None,
    c: any = None,
    d: any = None,
    e: any = None,
    f: any = None
) -> str {
    return twMerge(clsx([a, b, c, d, e, f]));
}
