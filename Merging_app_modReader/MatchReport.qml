import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtCharts 2.2

Dialog {
    id:screenPresence
    title: "Match Report"


    Connections{
        target: CUSTOMPRINT
        onSaveComplete :{
            console.log("Saved done")
            close()
        }
    }

    contentItem:Rectangle {
        id:contentRect
        anchors.fill: parent
        color: "grey"
        Rectangle
        {
            id:print_region
            width:parent.width
            height: parent.height*0.9
//            color: "white"
            color: "#ffffdd"
            border.width: 20
            border.color: "transparent"
            //        }
            Column{
                anchors.fill: parent
                Row {
                    //                anchors.fill: parent
                    width:parent.width
                    height: parent.height*0.9
                    PolarChartView {
                        id:preview
                        width: parent.width*0.5
                        height:parent.height
                        antialiasing: true
                        titleFont.family: "Helvetica"
                        titleFont.pointSize: 13
                        titleFont.bold: true
                        titleColor: "Red"
                        backgroundColor: "transparent"

                        Rectangle
                        {
                            id:circleRegion
                            visible: true
                            z:-1
                            width: preview.width/4
                            height: preview.height/4
                            radius:width/2
                            color: "black"
                        }

                        onWidthChanged:
                        {
                            circleRegionCordinates()
                        }

                        onHeightChanged:
                        {
                            circleRegionCordinates()
                        }
                        Component.onCompleted:
                        {
                            legend.visible = false;
                            //                        CUSTOMPRINT.print("")
                            //                        preview.grabToImage()
                        }

                        ValueAxis {
                            id: axisAngular
                            min: 0
                            max: 360
                            labelsFont.bold: true
                            labelsVisible: false
                        }

                        ValueAxis {
                            id: axisRadial
                            min: 0
                            max: 10
                            tickCount: max+1
                            labelsVisible: false
                        }

                        ScatterSeries {
                            id: scaterSeries
                            axisAngular: axisAngular
                            axisRadial: axisRadial
                            markerSize: 12
                            brushFilename: "qrc:/images/pin.png"
                        }

                        Repeater
                        {
                            id:numberRepeater
                            model:globalModelOfData
                            delegate: numberDelegate
                        }

                        Component {
                            id:numberDelegate
                            Item {
                                id:mainItem
                                width:15
                                height: 15
                                Rectangle
                                {
                                    Component.onCompleted:
                                    {
                                        var left = Qt.point(direction*1,score*1);
                                        left = preview.mapToPosition(left,scaterSeries);
                                        mainItem.x = preview.x + left.x - radius
                                        mainItem.y = preview.y + left.y - radius
                                        if(score > axisRadial.max)
                                            visible = false
                                        else
                                            visible = true
                                    }
                                    anchors.fill: parent
                                    radius:parent.width/2
                                    color:"red"
                                    Text{
                                        anchors.centerIn: parent
                                        text: index+1
                                    }
                                }
                            }
                        }

                    }

                    Rectangle {
                        width:parent.width*0.5
                        height:parent.height
                        color: "#ffffdd"
                        Column{
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            anchors.topMargin: 30
                            spacing: 20
                            Grid{
                                columns : 2
                                rows:8
                                columnSpacing:  40
                                rowSpacing: 20
                                id:shooterName
                                Text {
                                    text:"Date and Time"
                                    font.bold: true
                                }
                                Text {
                                    id:event_Date
                                    text:": " + new Date().toLocaleString()
                                    font.bold: true
                                }
                                Text {
                                    id:shooterLabel
                                    text:"Shooter Name"
                                    font.bold: true
                                }
                                Text {
                                    id:name
                                    text:": " + userName
                                    font.bold: true
                                }
                                Text {
                                    id:eventLabel
                                    text:"Event"
                                    font.bold: true
                                }
                                Text {
                                    id:event_Name
                                    text:": " + eventName
                                    font.bold: true
                                }
                                Text {
                                    text:"Total Shots"
                                    font.bold: true
                                }
                                Text {
                                    id:number_Shots
                                    text:": " + globalModelOfData.count
                                    font.bold: true
                                }
                                Text {
                                    text:"Total Score"
                                    font.bold: true
                                }
                                Text {
                                    id:event_score
                                    text:": " + totalScore.toFixed(2)
                                    font.bold: true
                                }
                                Text {
                                    text:"Average score"
                                    font.bold: true
                                }
                                Text {
                                    id:event_average
                                    text:": " + (totalScore/globalModelOfData.count).toFixed(2)
                                    font.bold: true
                                }
                                Text {
                                    text:"Average Time/Shot (In minutes)"
                                    font.bold: true
                                }
                                Text {
                                    id:average_time_shot
                                    //                            text:": " + averageTime
                                    text:": " + (totalTime/globalModelOfData.count).toFixed(2)
                                    font.bold: true
                                }
                                Text {
                                    id:series_wise_totalLabel
                                    text:"Series wise total"
                                    font.bold: true
                                }
                                Text {
                                    id:series_wise_total
                                    width: 150
                                    text:": " + getSeriesTotalText()
                                    font.bold: true
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }

            }
        }
        Rectangle {
            width:parent.width
            height:parent.height*0.1
            anchors.bottom: contentRect.bottom
            Row{
                anchors.centerIn: parent
                Button {
                    text:"Save"
                    onClicked:
                    {
                        printImage()
                    }
                }
                Button {
                    text:"Cancel"
                    onClicked:
                    {
                        close()
                    }
                }
            }
        }
    }

    function circleRegionCordinates()
    {
        var left = Qt.point(270,4);
        left = preview.mapToPosition(left,scaterSeries);
        var right = Qt.point(90,4);
        right = preview.mapToPosition(right,scaterSeries);
        var top = Qt.point(360,4);
        top = preview.mapToPosition(top,scaterSeries);
        var bottom = Qt.point(180,4);
        bottom = preview.mapToPosition(bottom,scaterSeries);

        circleRegion.x = left.x
        circleRegion.y = top.y
        circleRegion.width = right.x - left.x
        circleRegion.height = circleRegion.width
        circleRegion.radius = circleRegion.width/2

        updateModel()
    }

    function updateModel()
    {
        numberRepeater.model = null
        numberRepeater.model =globalModelOfData
    }

    function printImage()
    {
        var stat = print_region.grabToImage(function(result) {
            CUSTOMPRINT.printPNG(result.image); //result.image holds the QVariant
        });
    }

    function getSeriesTotalText()
    {
        var formatText = ""
        if(globalModelOfData.count === 0)
            return formatText
        var seriesScore = 0;
        for(var i=0; i<globalModelOfData.count; i++)
        {
            var scoreatIndex =globalModelOfData.get(i).calculatedscore*1
            seriesScore = seriesScore*1  +  (scoreatIndex.toFixed(1))*1
            console.log("Total score and score at current Index is",seriesScore,scoreatIndex)
            if( ( (i+1) % 10 == 0) && (i>0) )
            {
                var seriesId = Math.floor((i+1)/10)
                var seriesText = "Series " + seriesId*1
                seriesText += "(" + (seriesScore*1).toFixed(1) +") , "
                formatText = formatText + seriesText
                seriesScore = 0
            }
            if( (i === (globalModelOfData.count-1)) && ( (i+1)%10 != 0) )
            {
                var seriesIdNum = Math.floor((i+1)/10)
                var seriesScoreText = "Series " + seriesIdNum*1
                seriesScoreText += "(" + (seriesScore*1).toFixed(1) +")"
                formatText = formatText + seriesScoreText
                seriesScore = 0
            }
        }
        return formatText
    }

}
