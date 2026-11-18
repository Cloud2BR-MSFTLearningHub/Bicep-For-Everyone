import unittest
from pathlib import Path
from xml.etree import ElementTree

import markdown

from generate_catalog import MODULES, build_files


class CatalogTests(unittest.TestCase):
    def test_every_example_renders_as_a_catalog_table_row(self):
        source = build_files()[Path("docs/catalog.md")]
        rendered = markdown.markdown(source, extensions=["tables"])
        document = ElementTree.fromstring(f"<article>{rendered}</article>")
        rows = document.findall(".//tbody/tr")
        self.assertEqual(len(rows), len(MODULES))
        for row, module in zip(rows, MODULES):
            self.assertEqual(row.find("td/a").text, module[1])


if __name__ == "__main__":
    unittest.main()
