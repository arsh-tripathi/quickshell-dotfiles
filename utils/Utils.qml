pragma Singleton

import Quickshell

Singleton {
    function fitString(str: string, length: int): string {
        if (str.length > length) return str.slice(0, length);
        else return str.padEnd(length, '-');
    }
    function getNetFreqStr(freq: int): string {
        if (Math.abs(freq - 2400) <= 200)
            return "2.4GHz";
        else if (Math.abs(freq - 5000) <= 200)
            return "5.0GHz";
        else if (freq >= 5000)
            return "5.0GHz";
        else
            return "2.4GHz";
    }
}
