import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Canvas {
    width: 160
    height: 160
    id: clock
    required property int totalHours
    required property int totalMinutes
    required property int totalSeconds
    required property int hours
    required property int minutes
    required property int seconds

    property real angle: {
        if (totalHours + totalMinutes + totalSeconds === 0) return 2 * Math.PI;
        return ((hours * 3600 + minutes * 60 + seconds) / (totalHours * 3600 + totalMinutes * 60 + totalSeconds)) * 2 * Math.PI;
    }

    onSecondsChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d"); //get 2D Context
        ctx.reset();

        const centerX = width / 2;
        const centerY = height / 2;
        drawCircle(ctx, centerX, centerY, 75, "#C44658", "transparent", angle)
        drawCirc(ctx, centerX, centerY, 60, "#1E1E1E", "transparent", 2 * Math.PI)
        ctx.fillStyle = "white";
        ctx.font = "14pt 'FiraCode Nerd Font'";
        ctx.textAlign = "center";
        ctx.textBaseLine = "middle"
        const hoursText = hours > 0 ? (((hours < 10) ? "0" : "") + hours + ":") : "";
        const minutesText = ((minutes < 10) ? "0" : "") + minutes;
        const secondsText = ((seconds < 10) ? "0" : "") + seconds;
        ctx.fillText(hoursText + minutesText + ":" + secondsText, width / 2, height / 2 + 5)
    }

    function drawCircle(ctx, x: real, y: real, radius: real, fill, stroke, angle) {
        if (angle == 2 * Math.PI) {
            drawCirc(ctx, x, y, radius, fill, stroke)
            return;
        }
        ctx.save();
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.arc(x, y, radius, 3 * Math.PI / 2, 7 * Math.PI / 2 - angle, true);
        ctx.closePath();
        ctx.fillStyle = fill;
        ctx.fill();
        ctx.strokeStyle = stroke;
        ctx.stroke();
        ctx.restore();
    }

    function drawCirc(ctx, x: real, y: real, radius: real, fill, stroke) {
        ctx.save();
        ctx.beginPath();
        ctx.arc(x, y, radius, 0, 2 * Math.PI);
        ctx.fillStyle = fill;
        ctx.fill();
        ctx.strokeStyle = stroke;
        ctx.stroke();
        ctx.restore();
    }
}
