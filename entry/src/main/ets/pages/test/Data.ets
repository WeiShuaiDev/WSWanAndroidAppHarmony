export interface KeyItem {
  id: number,
  name: string
}

export class RouterParams {
  data: KeyItem[]

  constructor(array: KeyItem[]) {
    this.data = array
  }
}