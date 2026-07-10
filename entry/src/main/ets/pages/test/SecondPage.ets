import { KeyItem, RouterParams } from './Data'
import { JSON } from '@kit.ArkTS'

class SimpleDataKeySource implements IDataSource {
  private dataKeyList: KeyItem[] = []

  constructor(list: KeyItem[]) {
    this.dataKeyList = list
  }

  totalCount(): number {
    return this.dataKeyList.length
  }

  getData(index: number): KeyItem {
    return this.dataKeyList[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}


// 懒加载数据源类，必须继承 IDataSource
class DataKeySource implements IDataSource {
  // 存储真实数据
  private dataKeyList: KeyItem[] = []

  // 获取总条数
  totalCount(): number {
    return this.dataKeyList.length
  }

  // 根据下标获取单条数据
  getData(index: number): KeyItem {
    return this.dataKeyList[index]
  }

  private listener: DataChangeListener | null = null

  // 更新数据后通知UI刷新
  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listener = null
  }

  // 自定义方法：赋值/更新数据
  setData(list: KeyItem[]) {
    this.dataKeyList = list
    // 通知列表刷新
    this.notifyDataReload()
  }

  // 通知全量刷新
  private notifyDataReload() {
    // 调用注册的监听回调
    this.listener?.onDataReloaded()
  }

  //增加一条数据
  addData(item: KeyItem) {
    this.dataKeyList.push(item)
    this.listener?.onDataAdd(this.dataKeyList.length - 1)
  }

  //删除一条数据
  deleteData(index: number) {
    this.dataKeyList.splice(index, 1)
    this.listener?.onDataDelete(index)
  }

  //更新一条数据
  updateData(index: number, newItem: KeyItem) {
    this.dataKeyList[index] = newItem
    this.listener?.onDataChange(index)
  }

  //批量更新数据
  updateAllData(list: KeyItem[]) {
    this.dataKeyList = list
    this.listener?.onDataReloaded()
  }
}

//LazyForeach延时加载
@Entry
@Component
struct SecondPage {
  // 实例化数据源
  private dataKeySource: DataKeySource = new DataKeySource()
  private simpleDataKeySource: SimpleDataKeySource = new SimpleDataKeySource([{
    id: 1, name: 'test'
  }])

  aboutToAppear(): void {
    const initData: KeyItem[] = [
      { id: 10, name: 'first styles' },
      { id: 11, name: 'first state' },
      { id: 12, name: 'first prop' },
      { id: 13, name: 'first link' },
      { id: 14, name: 'first struct' },
      { id: 15, name: 'first provide' },
      { id: 16, name: 'first consume' },
      { id: 17, name: 'first if' },
      { id: 18, name: 'first foreach' }
    ]
    this.dataKeySource.setData(initData)
  }

  @State newData: KeyItem[] = (this.getUIContext().getRouter().getParams() as RouterParams).data

  build() {
    Column() {
      Button('增加一条数据')
        .width(200)
        .height(30)
        .backgroundColor(Color.Brown)
        .margin(10)
        .onClick(() => {
          this.dataKeySource.addData({ id: 10, name: "newData" })
        })

      Button('删除第一条数据')
        .width(200)
        .height(30)
        .backgroundColor(Color.Brown)
        .margin(10)
        .onClick(() => {
          this.dataKeySource.deleteData(0)
        })

      Button('修改第一条数据')
        .width(200)
        .height(30)
        .backgroundColor(Color.Brown)
        .margin(10)
        .onClick(() => {
          this.dataKeySource.updateData(0, { id: 1, name: 'new styles' })
        })

      Button('批量修改数据')
        .width(200)
        .height(30)
        .backgroundColor(Color.Brown)
        .margin(10)
        .onClick(() => {
          let newData = this.newData
          if (newData?.length > 0) {
            this.dataKeySource.updateAllData(newData)
          } else {
            console.log("更新数据失败")
          }
        })

      Button('返回上一个页面')
        .width(200)
        .height(30)
        .backgroundColor(Color.Brown)
        .margin(10)
        .onClick(() => {
          try {
            this.getUIContext().getRouter().showAlertBeforeBackPage({ message: "确定要跳转到FirstPage" })
          } catch (error) {
            console.log("jump page error info" + error)
          }
          this.getUIContext().getRouter().back()
        })

      LazyForEach(this.dataKeySource, (item: KeyItem, index: number) => {
        Text(index + ":id=" + item.id + ";name=" + item.name).fontSize(20)
      }, (item: KeyItem) => {
        return item.id.toString()
      })

      LazyForEach(this.simpleDataKeySource, (item: KeyItem, index: number) => {
        Text(index + ":id=" + item.id + ";name=" + item.name).fontSize(20)
      }, (item: KeyItem) => {
        return item.id.toString()
      })
      Text('FirstPage返回的数据')
      ForEach(this.newData, (item: KeyItem, index: number) => {
        Text(index + ":id=" + item.id + ";name=" + item.name).fontSize(20)
      })
    }.width('100%').height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}