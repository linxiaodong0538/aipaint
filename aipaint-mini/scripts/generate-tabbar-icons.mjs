import { mkdir, writeFile } from "node:fs/promises";
import { createRequire } from "node:module";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { Resvg } from "@resvg/resvg-js";
import { getIconData, iconToSVG, replaceIDs } from "@iconify/utils";

const __dirname = dirname(fileURLToPath(import.meta.url));
const require = createRequire(import.meta.url);
const lucideIcons = require("@iconify-json/lucide/icons.json");
const projectRoot = resolve(__dirname, "..");
const outputDir = resolve(projectRoot, "src/static/tabbar");

const icons = [
  {
    key: "home",
    name: "house"
  },
  {
    key: "templates",
    name: "layout-template"
  },
  {
    key: "works",
    name: "images"
  },
  {
    key: "me",
    name: "user-round"
  }
];

const colors = {
  normal: "#9b9b9b",
  active: "#000000"
};

function renderIcon(name, color) {
  const iconData = getIconData(lucideIcons, name);

  if (!iconData) {
    throw new Error(`Icon "${name}" was not found in @iconify-json/lucide.`);
  }

  const svg = iconToSVG(iconData, {
    height: "48",
    width: "48"
  });

  return `<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="${svg.attributes.viewBox}">${replaceIDs(
    svg.body
  ).replace(/currentColor/g, color)}</svg>`;
}

await mkdir(outputDir, { recursive: true });

for (const icon of icons) {
  for (const [state, color] of Object.entries(colors)) {
    const svg = renderIcon(icon.name, color);

    await writeFile(
      resolve(outputDir, `${icon.key}-${state}.svg`),
      svg,
      "utf8"
    );

    const png = new Resvg(svg, {
      fitTo: {
        mode: "width",
        value: 96
      }
    }).render().asPng();

    await writeFile(resolve(outputDir, `${icon.key}-${state}.png`), png);
  }
}
