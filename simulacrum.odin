package simulacrum

import "base:runtime"
import "core:fmt"
import "core:os"



main :: proc() {
    arguments: []string = os.args

    if len(arguments) > 4 do runtime.exit(1)

     
}

