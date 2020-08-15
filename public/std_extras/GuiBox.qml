// Предназначение - показать набор элементов гуи
// 1 набор A выбирается из массива input - выбираются только элементы соответствующие crit
// 2 для каждого `a` из A рисуется кнопка
// 3 по нажатию на эту кнопку показывается гуи `a`

// два вида гуи на текущий момент:
// - элемент сам по себе
// - диалог
// критерий диалога что у него есть метод open

Column {
  id: mainco
  
  spacing: 2 // промежуток между различными гуи
  

  property var input: []
  
//  function crit(item) {
//    return false;
//  }
  
  // todo сделать критерий функций. мб оформить как сигнал. или как функцию которую будут оверрайдить

  property var myarr: {
    var res = input.filter( mainco.crit );
//    console.log("guibox crit=",crit,"myarr=",res);
    return res;
  }

      Repeater {
        model: myarr.length

        Column {
          id: outerco
          //height: co1.visible ? implicitHeight : btn.height
          // css.border: "1px solid grey"
        
          Button {
            id: btn
            //width: 200
            //left: 20
            
            property var item: myarr[ index ]
            
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