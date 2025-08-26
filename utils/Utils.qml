pragma Singleton

import Quickshell

Singleton {
    function fitString(str: string, length: int): string {
        if (str.length > length) return str.slice(0, length);
        else return str.padEnd(length, '-');
    }
}
