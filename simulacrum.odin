package simulacrum

import "core:path/filepath"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    arguments: []string = os.args

    if len(arguments) > 3 do runtime.exit(1)

    changeName(arguments[1], arguments[2], preview=true)

    current_loop: for {
        confirm: [4]byte
        fmt.print("Proceed with operation(y/n): ")
        os.read(os.stdin, confirm[:])
        switch confirm[0] {
        case 'y':
            changeName(arguments[1], arguments[2], preview=false)
            break current_loop
        case 'n':
            break current_loop
        case: 
            fmt.println("Invalid input. Enter y or n!")
            continue
        }
    }     
}

changeName :: proc(args1: string, args2: string, preview: bool) {
    working_dir, err := os.get_working_directory(context.allocator)
    if err != nil {
        fmt.println("Cant read current directory!")
        runtime.exit(1)
    }
    defer delete(working_dir)

    walker: os.Walker =  os.walker_create(working_dir)
    defer os.walker_destroy(&walker)

    for item in os.walker_walk(&walker) {
        path, err := os.walker_error(&walker)
        if err != nil {
            fmt.printfln("error at %s: %s", path, err)
            continue
        }

        if item.type == .Directory && strings.has_prefix(item.name, ".") {
            os.walker_skip_dir(&walker)
            continue
        }

        if preview {
            if item.name == args1 {
                fmt.printfln("%s -> %s", item.fullpath, args2)
                
            }
        } else {
            if item.name == args1 {
                new_path, _ := filepath.join([]string{filepath.dir(item.fullpath), args2}, context.temp_allocator)
                err := os.rename(item.fullpath, new_path)
                if err != nil {
                    fmt.printfln("Can't rename file: %v", err)
                } else {
                    fmt.printfln("%s has been renamed to %s", item.fullpath, args2)
                }
            }
        } 
    }   
    path, error := os.walker_error(&walker)
    if err != nil do fmt.printfln("failed walking %s: %v", path, err)
}

