@Entry
@Component
@Preview
struct FirstPage {
  @State message: string = 'Hello World'

  //夸组件数据传输Provide
  //@Provide num: number = 1
  //夸组件别名设置
  @Provide('a') num: number = 1

  //自定义局部样式
  @Styles
  sty(){
    .width(200)
    .height(50)
    .backgroundColor(Color.Orange)
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button('Button').sty()
        .margin(10)
        .onClick(() => {
          this.message = 'Hello Parent'
        })
      Divider()
      Text(this.num.toString())
        .onClick(() => {
          this.num = 2
        })
        .backgroundColor(Color.Yellow)
        .width(200)
        .height(50)
        .fontSize(20)
      Divider()
      Child({ name: this.message })
    }.width('100%').height('100%')
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
        .width(200)
        .height(50)
        .backgroundColor(Color.Blue)
        .margin(10)
        .onClick(() => {
          this.name = 'Hello Child'
        })
      Divider()
      ChildChild()
    }
  }
}

@Component
struct ChildChild {
  //夸组件数据传输Consume
  //@Consume num: number
  //夸组件别名设置
  @Consume('a') num: number

  build() {
    Column() {
      Text(this.num.toString())
        .onClick(() => {
          this.num = 3
        })
        .backgroundColor(Color.Red)
        .width(200)
        .height(50)
        .fontSize(20)
    }
  }
}



