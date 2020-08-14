// Предназначение - показать набор элементов гуи
// 1 для каждого элемента набора рисуется кнопка
// 2 по нажатию на эту кнопку показывается содержимое`a`
// 3 фзаголовок для кнопки берется из проперти .title

// два вида гуи на текущий момент:
// - элемент сам по себе
// - диалог
// критерий диалога что у него есть метод open

Column {
  id: mainco
  
  spacing: 2 // промежуток между различными гуи

  property var input: []
  // набор item-ов которые представляют гуи для добавки
  // причем каждый итем

      Repeater {
        model: input.length

        Column {
          id: outerco
          //height: co1.visible ? implicitHeight : btn.height
          // css.border: "1px solid grey"
        
          Button {
            id: btn
            //width: 200
            //left: 20
            
            property var item: input[ index ]
            
            function isdlg() { return !!item.open; }
            
            text: { 
              // мы там теги пишем - уберем ка их
              var q = (item.title || "кнопка");
              var q2= q.replace( /<[^]+>/,"" );
              if (!co1.visible) q2 = q2 + "..";
              q2="&gt;&nbsp;"+q2;
              return q2;
              //if (q.indexOf("<") >= 0) return q.substr( 0,q );
              //return q;
            }
            
            onClicked: {
              if (isdlg())
                item.open();
              else
                co1.visible = !co1.visible;
            }
            
            onItemChanged: {
              // console.log("item arrived",item );
              // перетаскиваем к себе этот итем
              if (!isdlg()) item.parent = co1;
            }
          }
          Text {
            text: " "
            height: 2
          }
          
          Column {
            id: co1
            height: 0
            css.overflow: "hidden"
            //height: visible ? implicitHeight : 0
            //width: visible ? implicitWidth : 0
            
            ParamUrlHashing {
              name: scopeNameCalc.globalName
              // onNameChanged: console.log("PUH name=",name );
              id: hasher
              property: "visible"
            }

            ScopeCalculator {
              id: scopeNameCalc
              name: "gui_visible" // она обопрется на ScopeName который там нормально выставлен
              target: btn.item
             // globalName, globalText
            }
          } // inner col
        } // outer col

      } // repeatr

}