resource "null_resource" "vscode" {

    provisioner "local-exec" {
        command = "[ ! -d \"/Applications/VSCodium.app\" ] && brew install vscodium"
    }
}
