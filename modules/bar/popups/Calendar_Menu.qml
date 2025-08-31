import QtQuick.Layouts
import qs.widgets

PopupMenu {
    id: calendar_popup
    implicitHeight: 400
    implicitWidth: 300
    ColumnLayout {
        CalendarWidget {}
    }
}
