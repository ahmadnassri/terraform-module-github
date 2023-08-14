# Template for Terraform Modules Templates Repositories

Template for Terraform Modules Templates Repositories

[![license][license-img]][license-url]
[![release][release-img]][release-url]

## Usage

#### Terraform Module Template

> Automated through [`@ahmadnassri/action-template-repository-sync`][]

1.  create a repository from the module
2.  clone locally
3.  update `colophon.yml`, `docs/README.md` with info about the project

## Local Automation

| command      | description                                        |
|--------------|----------------------------------------------------|
| pull         | pull latest containers                             |
| lint         | run mega-linter                                    |
| readme       | run readme action                                  |
| init         | init terraform & install plugins                   |
| upgrade      | upgrade terraform provider                         |
| refresh      | refresh state                                      |
| format       | clean up terraform file                            |
| validate     | validate your changes                              |
| unlock       | force unlock remote state                          |
| list         | list terraform resources                           |
| plan         | show terraform plan                                |
| apply        | apply terraform changes                            |
| apply-target | apply terraform changes to specific target         |
| shell        | start the container shell                          |
| clean        | remove running containers, volumes & anything else |
| help         | display this help                                  |

> **Note:**  
> Your main `README.md` file is in `docs/README.md`, the file at root is generated using [pandoc][] using the provided [template][].
>
> You should run `make readme` after any change to `docs/README.md` and before commit / push

  [`@ahmadnassri/action-template-repository-sync`]: https://github.com/ahmadnassri/action-template-repository-sync
  [pandoc]: https://pandoc.org/
  [template]: ./docs/README.template

----
> Author: [Ahmad Nassri](https://www.ahmadnassri.com/) &bull;
> Twitter: [@AhmadNassri](https://twitter.com/AhmadNassri)

[license-url]: LICENSE
[license-img]: https://badgen.net/github/license/ahmadnassri/template-terraform-module

[release-url]: https://github.com/ahmadnassri/template-terraform-module/releases
[release-img]: https://badgen.net/github/release/ahmadnassri/template-terraform-module
