import { KeyItem, RouterParams } from './Data'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct FirstPage {
  @State message: string = 'default data'
  //夸组件数据传输Provide
  //@Provide num: number = 1
  //夸组件别名设置数据传输
  @Provide('a') num: number = 1
  //是否显示子组件
  @State isShowChild: boolean = false
  //列表数据
  @State dataList: String[] = ['styles', 'state', 'prop', 'link', 'struct', 'provide', 'consume', 'if', 'foreach']
  //唯一key列表数据
  @State dataKeyList: KeyItem[] = []

  aboutToAppear(): void {
    this.dataKeyList = [
      { id: 1, name: 'first styles' },
      { id: 2, name: 'first state' },
      { id: 3, name: 'first prop' },
      { id: 4, name: 'first link' },
      { id: 5, name: 'first struct' },
      { id: 6, name: 'first provide' },
      { id: 7, name: 'first consume' },
      { id: 8, name: 'first if' },
      { id: 9, name: 'first foreach' }
    ]
  }

  //自定义局部样式
  @Styles
  sty(){
    .width(200)
    .height(30)
    .backgroundColor(Color.Orange)
  }

  //页面跳转
  async routePage() {
    let data = this.dataKeyList
    let options: router.RouterOptions = {
      url: 'pages/test/SecondPage',
      params: new RouterParams(data)
    }
    this.getUIContext()
      .getRouter()
      .pushUrl(options)
      .then(() => {
        console.info('jump success')
      })
      .catch((err: ESObject) => {
        console.info('jump error')
      })

  }

  build() {
    Column() {
      //数据渲染
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button('修改数据').sty()
        .margin(10)
        .onClick(() => {
          this.message = 'update data'
        })
      //数据传输
      Text(this.num.toString())
        .onClick(() => {
          this.num = 2
        })
        .backgroundColor(Color.Yellow)
        .width('100%')
        .height(50)
        .fontSize(20)
      //条件控制
      Button('控制子组件显示')
        .width(200)
        .height(30)
        .backgroundColor(Color.Green)
        .margin(10)
        .onClick(() => {
          this.isShowChild = !this.isShowChild
        })
      if (this.isShowChild) {
        Child({ name: this.message })
      }
      //列表数据循环显示
      ForEach(this.dataList, (item: string, index: number) => {
        Text(index + ":" + item).fontSize(20)
      })
      //唯一key列表数据循环显示
      ForEach(this.dataKeyList, (item: KeyItem, index: number) => {
        Text(index + ":id=" + item.id + ";name=" + item.name).fontSize(20)
      }, (item: KeyItem) => {
        return item.id.toString()
      })
      Button('跳转到SecondPage页面')
        .width(200)
        .height(30)
        .backgroundColor(Color.Gray)
        .margin(10)
        .onClick(() => {
          this.routePage()
        })
      //LazyForEach用法可以看SecondPage页面
    }.width('100%').height('100%').alignItems(HorizontalAlign.Start)
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
      Button('子组件')
        .width(200)
        .height(30)
        .backgroundColor(Color.Blue)
        .margin(10)
        .onClick(() => {
          this.name = 'child update data'
        })
      ChildChild()
    }.alignItems(HorizontalAlign.Start)
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
        .width('100%')
        .height(50)
        .fontSize(20)
    }.alignItems(HorizontalAlign.Start)
  }
}



