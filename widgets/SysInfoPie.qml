import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Canvas {
    width: 120
    height: 120
    id: clock
    required property real usage
    required property real total
    required property string symbol

    property real angle: 2 * Math.PI * usage / total

    onUsageChanged: requestPaint()
    onTotalChanged: requestPaint()
    onSymbolChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d"); //get 2D Context
        ctx.reset();

        const centerX = width / 2;
        const centerY = height / 2;
        drawCircle(ctx, centerX, centerY, 55, "#C44658", "#C44658", angle)
        drawCirc(ctx, centerX, centerY, 55, "transparent", "#C44658", angle)
        drawCirc(ctx, centerX, centerY, 45, "#1E1E1E", "#C44658", 2 * Math.PI)
        ctx.fillStyle = "white";
        ctx.font = "25pt 'FiraCode Nerd Font'";
        ctx.textAlign = "center";
        ctx.textBaseLine = "middle"
        ctx.fillText(symbol, width / 2 - 7, height / 2 - 5)
        ctx.font = "12pt 'FiraCode Nerd Font'";
        ctx.fillText(Math.floor(usage * 100 / total) + "%", width / 2, height / 2 + 20)
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
