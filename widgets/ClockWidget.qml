import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Canvas {
    width: 160
    height: 160
    id: clock
    required property int hours
    required property int minutes
    required property int seconds

    property real hourAngle: (hours % 12 + minutes  / 60.0) * 30 * Math.PI / 180
    property real minuteAngle: (minutes + seconds / 60.0) * 6 * Math.PI / 180
    property real secondAngle: seconds * 6 * Math.PI / 180

    onSecondsChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d"); //get 2D Context
        ctx.reset();

        const centerX = width / 2;
        const centerY = height / 2;
        drawCircle(ctx, centerX, centerY, 75, "#1E1E1E", "transparent", true)
        drawHand(ctx, hourAngle, 45, 7, "white", centerX, centerY);
        drawHand(ctx, minuteAngle, 60, 3, "white", centerX, centerY);
        drawHand(ctx, secondAngle, 65, 1.5, "#C44658", centerX, centerY);
        drawCircle(ctx, centerX, centerY, 4.5, "white", "transparent", false)
    }

    function drawCircle(ctx, x: real, y: real, radius: real, fill, stroke, hasShadow: bool) {
        ctx.save();
        ctx.beginPath();
        ctx.arc(x, y, radius, 0, 2 * Math.PI);
        ctx.fillStyle = fill;
        if (hasShadow) {
            ctx.shadowColor = "white";
            ctx.shadowBlur = 3;
        }
        ctx.fill();
        ctx.strokeStyle = stroke;
        ctx.stroke();
        ctx.restore();
    }

    function drawHand(ctx, angle: real, length: real, width: real, color, x: real, y: real) {
        // ctx.save();
        ctx.beginPath();
        ctx.moveTo(x, y);
        ctx.lineTo(x + length * Math.sin(angle), y - length * Math.cos(angle));
        ctx.strokeStyle = color;
        ctx.lineCap = "round"
        ctx.lineWidth = width;
        ctx.stroke();
    }
}
