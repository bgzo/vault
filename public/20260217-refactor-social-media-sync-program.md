---
title: 重構 TG 機器人
aliases: ['重構 TG 機器人']
created: 2026-02-17 14:36:01
modified: 2026-04-11 18:50:18
published: 2026-02-17 14:36:01
tags: ['golang', 'public', 'telegram-bot', 'writing/lab']
draft: False
description: 不懂的點（學習筆記） Golang 跑測試 爲啥可以直接測試？測試在另一個文件裏面 service_test.go？ ==猜測是按文件夾測試== Golang 的接口實現 比較變態，沒有顯示聲明，差點沒看出來是 Provider 是 Service 的接口實現。 如果想實現一個接口，能否快速生成這個接口的全部方法？要不然還得反過頭來反覆查找，感覺如果沒有這個語法糖有點坐牢，而且沒有顯示聲明，也不容...
---

## 不懂的點（學習筆記）

### Golang 跑測試

```shell
go test ./internal/service/syncservice
```

> 爲啥可以直接測試？測試在另一個文件裏面 `service_test.go`？

==猜測是按文件夾測試==

### Golang 的接口實現

比較變態，沒有顯示聲明，差點沒看出來是 Provider 是 Service 的接口實現。

> 如果想實現一個接口，能否快速生成這個接口的全部方法？要不然還得反過頭來反覆查找，感覺如果沒有這個語法糖有點坐牢，而且沒有顯示聲明，也不容易分辨接口實現。

via: https://draven.co/golang/docs/part2-foundation/ch04-basic/golang-interface/

## Golang make 構造數據結構

via:https://draven.co/golang/docs/part2-foundation/ch05-keyword/golang-make-and-new/

### Golang 編程模式

管道基礎用法：

```go
package main

import (
	"fmt"
)

// 生成整數序列的函數
// `gen` 函數生成一個通道並返回，它使用一個 goroutine 來將輸入的整數序列寫入通道中
func gen(nums ...int) <-chan int {
	out := make(chan int)
	go func() {
		defer close(out)
		for _, n := range nums {
			out <- n
		}
	}()
	return out
}

// 對整數進行平方操作的函數
// `square` 函數接收一個整數類型的通道作爲輸入，對每個輸入的整數進行平方操作，並將結果寫入一個新的整數類型的通道中
func square(in <-chan int) <-chan int {
	out := make(chan int)
	go func() {
		defer close(out)
		for n := range in {
			out <- n * n
		}
	}()
	return out
}

// 對整數進行求和操作的函數
// `sum` 函數接收一個整數類型的通道作爲輸入，對其中的整數進行求和操作，並返回求和的結果
func sum(in <-chan int) int {
	sum := 0
	for n := range in {
		sum += n
	}
	return sum
}

func main() {
	// 生成整數序列
	nums := gen(2, 3, 4)

	// 對整數進行平方操作
	sq := square(nums)

	// 對整數進行求和操作
	res := sum(sq)

	fmt.Println(res) // 輸出 29
}
```

進階用法：

```go
// 一個代理函數
type EchoFunc func ([]int) (<- chan int)
type PipeFunc func (<- chan int) (<- chan int)

func pipeline(nums []int, echo EchoFunc, pipeFns ... PipeFunc) <- chan int {
  ch  := echo(nums)
  // pipeFns 這裏是切片，所以i 是索引
  for i := range pipeFns {
	  // 把當前的 channel ch 傳給第 i 個處理函數
	  // 這個處理函數會返回一個“新的 channel”
	  // 用新的 channel 覆蓋舊的 ch
    ch = pipeFns[i](ch)
  }
  return ch
}

var nums = []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
// range 的對象只有一個：最終返回的 channel
// pipeline 這裏是管道，所以結果是最終管道流出的值
for n := range pipeline(nums, gen, odd, sq, sum) {
    fmt.Println(n)
}
```

上下兩個 range 行爲不一致，是 golang 的「多態語法」，並不是「統一抽象」，`range` 在切片中代表索引，在 channel 中代表終點值，更多關於 range 的語法參考： https://www.runoob.com/go/go-range.html

via: (8/10) https://coolshell.cn/articles/21228.html;https://www.bilibili.com/read/cv23233345

Source via: https://note.bgzo.cc/weekly/20260217-refactor-social-media-sync-program