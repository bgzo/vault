---
draft: False
aliases: ['如何構建命令行程序', 'How to build commnd-line program']
created: 2025-08-30 15:19:36
modified: 2025-08-30 15:20:49
title: How to build commnd-line program
tags: ['writing/how-to']
description: python3 argparse document via https//docs.python.org/3/library/argparse.html#module-argparse, https//docs.python.org/3/howto/argparse.html click via https//www.youtube.com/watch?v=FWacanslfFM getopt S...
---

## python3

### `argparse`

document via: https://docs.python.org/3/library/argparse.html#module-argparse, https://docs.python.org/3/howto/argparse.html

```python
import argparse

if __name__ == "__main__":
    # NOTE: args parse starting
    parser = argparse.ArgumentParser(
        description="Format text")

    parser.add_argument("file",
        type=argparse.FileType('r', encoding='UTF-8'),
        # NOTE: open don't support GBK open
            # UnicodeDecodeError: 'gbk' codec can't decode byte 0x9d in
            # position 8:
            # illegal multibyte sequence
        help="Add the source file to format")

    parser.add_argument("-o", "--output", action="store"
        ,help = "Flag this will be output instead of origin file")

    args = parser.parse_args()
    # `--help` argument FREE!
    # NOTE: args parse ending

    if args.file:
      lines = proof(args.file)
    if args.output:
      output_lines(args.output, lines)
    else:
      output_lines(args.file.name, lines)
```

### `click`

<iframe src="https://www.youtube.com/embed/FWacanslfFM" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=FWacanslfFM' target='_blank' class='external-link'>https://www.youtube.com/watch?v=FWacanslfFM</a></center>

```python
from datetime import datetime
import click
import json
import os
from file import load, save, exists

@click.command()
@click.argument("title")
@click.option("--content", prompt=True, help="Content of the note")
@click.option("--tags", help="Comma-separated list of tags")
@click.pass_context
def create(ctx: click.Context, title: str, content: str, tags: str):
    """Create a new note."""
    notes_directory = ctx.obj["notes_directory"]
    note_name = f"{title}.txt"
    if (notes_directory / note_name).exists():
        click.echo(f"Note with title '{title}' already exists.")
        exit(1)

    note_data = {
        "content": content,
        "tags": tags.split(",") if tags else [],
        "created_at": datetime.now().isoformat(),
    }
    with open(notes_directory / note_name, "a+") as file:
        json.dump(note_data, file)
    click.echo(f"Note '{title}' created.")
```

### `getopt`

Source via: https://note.bgzo.cc/weekly/build-commndline-program