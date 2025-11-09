import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.utils
import qs.services

RowLayout {
    id: root
    visible: false
    property int currYear: parseInt(Time.format("yyyy"))
    property alias date: dateSpin.currentIndex
    property alias month: monthSpin.currentIndex
    property alias year: yearSpin.currentIndex
    onDateChanged: if (date == 0) reset();
    onMonthChanged: if (month == 0) reset();
    onYearChanged: if (year == 0) reset();
    function reset() {
        dateSpin.currentIndex = 0
        monthSpin.currentIndex = 0
        yearSpin.currentIndex = 0
    }
    StyledTumbler {
        id: dateSpin
        hasNull: true
        wrap: false
        model: Utils.getMonthNumDays(root.month, root.year) + 1
        visibleItemCount: 3
        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, Tumbler.Center)
        }
        Component.onCompleted: {
            positionViewAtIndex(currentIndex, Tumbler.Center)
        }
    }
    StyledTumbler {
        id: monthSpin
        hasNull: true
        model: 13
        wrap: false
        visibleItemCount: 3
        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, Tumbler.Center)
        }
        Component.onCompleted: {
            positionViewAtIndex(currentIndex, Tumbler.Center)
        }
    }
    StyledTumbler {
        id: yearSpin
        offset: root.currYear - 1
        hasNull: true
        model: 100
        wrap: false
        visibleItemCount: 3
        Component.onCompleted: {
            positionViewAtIndex(currentIndex, Tumbler.Center)
        }
    }
}
