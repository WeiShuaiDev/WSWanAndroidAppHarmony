@Entry
@Component
@Preview
struct FirstPage {
  @State message: string = 'Hello World'

  //自定义局部样式
  @Styles
  sty(){
    .width(200)
    .height(50)
    .backgroundColor(Color.Orange)
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Button('Button').sty()
          .margin(10)
          .onClick(() => {
            this.message = 'Hello Parent'
          })
        Child({ name: this.message })
      }.width('100%')
    }.height('100%')
  }
}

//自定义全局样式
@Styles
function sty() {
  .width(300)
  .height(50)
  .backgroundColor(Color.Green)
}

@Component
struct Child {
  //单向传输
  //@Prop name: string;

  //双向传输
  @Link name: string;

  build() {
    Column() {
      Text(this.name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button('Child View')
        .width(300)
        .height(50)
        .backgroundColor(Color.Blue)
        .onClick(() => {
          this.name = 'Hello Child'
        })
    }
  }
}