# Mkdocs 初始设置

mkdocs 可以配合 github_pages 展示非常不错的网页效果

这里给出我们使用的 mkdocs.yml 和 gitaction 文档

## mkdocs.yml

```yml
site_name: lemon

theme:

  name: material

  language: zh

  # 网站左上角显示的logo

  logo: img/log.png

  # 网站图标

  favicon: img/yileina.ico

  features:

    - navigation.instant

    - navigation.tabs

    - navigation.sections

    - navigation.expand

    - navigation.top

  palette:

    - media: "(prefers-color-scheme: light)"

      scheme: default

      primary: indigo

      accent: red

      toggle:

        icon: material/toggle-switch-off-outline

        name: Switch to dark mode

    # 深色模式

    - media: "(prefers-color-scheme: dark)"

      scheme: slate

      primary: deep orange

      accent: red

      toggle:

        icon: material/toggle-switch

        name: Switch to light mode

extra_css:

  - stylesheets/extra.css

markdown_extensions:

  - attr_list

copyright: Copyright © 2022 Apostle-lemon

extra:

  # 右下角的超链接

  social:

    - icon: fontawesome/brands/github

      link: #

      name: github
```

## Git Action

```yml
name: mkdocs_auto_deploy

  

on:

  push:

    branches:

      - main

  pull_request:

    branches:

      - main

  

jobs:

  deploy:

    runs-on: ubuntu-latest

    steps:

      - uses: actions/checkout@v3

      - uses: actions/setup-python@v4

        with:

          python-version: '3.10'

      - run: pip install mkdocs-material

      - run: mkdocs gh-deploy --force
```
