import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.utils

RowLayout {
    id: root
    visible: false
    property alias date: dateSpin.value
    property alias month: monthSpin.value
    property alias year: yearSpin.value
    SpinBox {
        id: dateSpin
        editable: true
        implicitWidth: 50
        from: 1
        to: Utils.getMonthNumDays(root.month, root.year)
        value: 1

        validator: IntValidator { bottom: 1; top: Utils.getMonthNumDays(root.month, root.year) }

        textFromValue: function(value) {
            return value.toString().padStart(2, "0")
        }

        valueFromText: function(text) {
            return parseInt(text)
        }
    }
    SpinBox {
        id: monthSpin
        editable: true
        from: 1
        to: 12
        value: 1
        implicitWidth: 50

        validator: IntValidator { bottom: 1; top: 12 }

        textFromValue: function(value) {
            return value.toString().padStart(2, "0")
        }

        valueFromText: function(text) {
            return parseInt(text)
        }
    }
    SpinBox {
        id: yearSpin
        editable: true
        from: 0
        to: 2400
        value: 2025
        implicitWidth: 50

        validator: IntValidator { bottom: 0; top: 2400 }

        textFromValue: function(value) {
            return value.toString().padStart(4, "0")
        }

        valueFromText: function(text) {
            return parseInt(text)
        }
    }
}
