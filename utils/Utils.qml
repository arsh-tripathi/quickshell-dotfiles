pragma Singleton

import Quickshell

Singleton {
    function fitString(str: string, length: int): string {
        if (str.length > length) return str.slice(0, length);
        else return str.padEnd(length, ' ');
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
    function getTimeStr(seconds: real): string {
        let hours = Math.floor(seconds / 3600);
        let minutes = Math.floor((seconds % 3600) / 60);
        if (hours === 0)
            return minutes + "min";
        else 
            return hours + "h " + minutes + "min";
    }
    function offsetDate(curr_date: date, local_offset: int, offset: int): date {
        curr_date.setSeconds(curr_date.getUTCSeconds() - local_offset + offset);
        return curr_date;
    }
    function removeElement(l: list<var>, index: int): list<var> {
        console.log(index, l)
        if (index < 0 || index >= l.length) return;
        for (var i = index; i < l.length; i++) {
            l[i] = l[i+1]
        }
        l.length -= 1;
        return l;
    }
    function getMonthNumDays(month: int, year: int): int {
        const isLeap = (year % 400 === 0) || (year % 100 !== 0 && year % 4 === 0)
        if (month === 1 || month === 3 || month === 5 || month === 7 || month === 8 || month === 10 || month === 12)
            return 31;
        else if (month === 2)
            return (isLeap) ? 29: 28;
        else
            return 30;
    }
    function getCalenderHeader(month: int, year: int): string {
        let monthString = 
            (month === 1) ? "January" :
            (month === 2) ? "February" :
            (month === 3) ? "March" :
            (month === 4) ? "April" :
            (month === 5) ? "May" :
            (month === 6) ? "June" :
            (month === 7) ? "July" :
            (month === 8) ? "August" :
            (month === 9) ? "September" :
            (month === 10) ? "October" :
            (month === 11) ? "November" :
            "December";
        return monthString + " - " + year;
    }
}
