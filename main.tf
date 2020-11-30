resource "null_resource" "repository" {
  # See: https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
  provisioner "local-exec" {
    command = "sudo apt install -y extrepo && sudo extrepo enable vscodium"
    interpreter = var.default_interpreter
  }
}

resource "null_resource" "vscode" {

  provisioner "local-exec" {
    command = "sudo apt update && sudo apt install -y codium"
    interpreter = var.default_interpreter
  }
}

resource "null_resource" "set_microsoft_marketplace" {
    # By default in VSCodium, the product.json file is set up to use open-vsx.org
    # as extension gallery, which has an adapter to the Marketplace API used by VS Code.
    # This resource update the default open-vsx gallery to the Microsoft marketplace.
    # See: https://github.com/VSCodium/vscodium/blob/master/DOCS.md#extensions-marketplace

    provisioner "local-exec" {
        command = "sed -i '' 's,https://open-vsx.org/vscode/gallery,https://marketplace.visualstudio.com/_apis/public/gallery,g' product.json"
        interpreter = var.default_interpreter
        working_dir = "/usr/share/codium/resources/app/"
    }

    provisioner "local-exec" {
        command = "sed -i '' 's,https://open-vsx.org/vscode/item,https://marketplace.visualstudio.com/items,g' product.json"
        interpreter = var.default_interpreter
        working_dir = "/usr/share/codium/resources/app/"
    }
}

resource "null_resource" "vscode_extension" {
    for_each = toset(var.extensions)

    provisioner "local-exec" {
        command = "codium --install-extension ${each.key}"
        interpreter = var.default_interpreter
    }
}
