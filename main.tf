resource "null_resource" "vscode" {

    provisioner "local-exec" {
        command = "[ ! -d \"/Applications/VSCodium.app\" ] && brew install vscodium"
        interpreter = var.default_interpreter
    }
}

resource "null_resource" "set_microsoft_marketplace" {
    # By default in VSCodium, the product.json file is set up to use open-vsx.org
    # as extension gallery, which has an adapter to the Marketplace API used by VS Code.
    # This resource update the default open-vsx gallery to the Microsoft marketplace.
    # See: https://github.com/VSCodium/vscodium/blob/master/DOCS.md#extensions-marketplace

    provisioner "local-exec" {
        # The -i '' is mandatory here because of the BSD sed verison that expect
        # a suffix. The GNU sed take this suffix as optional.
        # See: https://stackoverflow.com/questions/16745988/sed-command-with-i-option-in-place-editing-works-fine-on-ubuntu-but-not-mac
        command = "sed -i '' 's,https://open-vsx.org/vscode/gallery,https://marketplace.visualstudio.com/_apis/public/gallery,g' product.json"
        interpreter = var.default_interpreter
        working_dir = "/Applications/VSCodium.app/Contents/Resources/app"
    }

    provisioner "local-exec" {
        command = "sed -i '' 's,https://open-vsx.org/vscode/item,https://marketplace.visualstudio.com/items,g' product.json"
        interpreter = var.default_interpreter
        working_dir = "/Applications/VSCodium.app/Contents/Resources/app"
    }
}

resource "null_resource" "vscode_extension" {
    for_each = toset(var.extensions)

    provisioner "local-exec" {
        command = "code --install-extension ${each.key}"
        interpreter = var.default_interpreter
    }
}
