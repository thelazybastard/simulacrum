package simulacrum

import "core:path/filepath"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

undos: [dynamic]Undo

Undo :: struct {
    new_name: string,
    old_name: string
}

main :: proc() {
    arguments: []string = os.args

    if len(arguments) > 3 || len(arguments) < 3 do runtime.exit(1)

    if arguments[1] == "undo" && arguments[2] == "rename" {
        undo_entries()
        return
    } else {
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
                new_path, _ := filepath.join([]string{filepath.dir(item.fullpath), args2}, context.allocator)
                save_entries(new_path, item.fullpath)
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

save_entries :: proc(new_name: string, old_name: string) {
    u := Undo {
        new_name = strings.clone(new_name),
        old_name = strings.clone(old_name),
    }
    append(&undos, u)

    data, err := json.marshal(undos)
    if err != nil {
        return
    }
    defer delete(data)

    ok := os.write_entire_file("undo.json", data)
    if ok != nil {
        fmt.println("Unable to store current data!")
    }
}

undo_entries :: proc(allocator := context.allocator) {
    data, ok := os.read_entire_file("undo.json", context.allocator)
    if ok != nil {
        fmt.println("Unable to read the previous operation's data!")
    }
    defer delete(data)
    
    u: [dynamic]Undo
    json.unmarshal(data, &u, allocator = allocator)
    
    for i in u {
        err := os.rename(i.new_name, i.old_name)
        if err != nil {
            fmt.println("Can't undo operation!")
        } else {
            fmt.printfln("%s has been reverted to %s", i.new_name, i.old_name)
        }
    }
}

