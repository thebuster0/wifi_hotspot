# wifi_hotspot

一个<del>基佬</del>正常人做的WIFI热点创建程序 （虽然部分代码有点像Kingron/wifi的代码）
这是一个基于Kingron/wifi的程序做的改良版/修改版，现在是版本1.0，暂时只支持简体中文版的Windows
作者的程序<a href="https://github.com/kingron/wifi">Kingron/wifi</a>

<hr>

Q&A

Q: 这个程序是跨平台的吗？
<br>
A: 不，这个程序<b>不是跨平台的</b> 这个程序仅支持Windows
<br>
<br>
Q: 这个代码很像<a href="https://github.com/kingron/wifi">Kingron/wifi</a>的代码，你是不是抄袭的?
<br>
A: 都说了这是<a href="https://github.com/kingron/wifi">Kingron/wifi</a>的改良版/修改版，部分代码是我改的 本来想弄成EXE程序的 就是现在出了一点小问题
<br>
<br>
Q: 你弄得代码侵权了，我怎么让你删除啊？
<br>
A: 如果我侵权，请你在Issues那里留个 “你的代码是侵权的” 类似的东西 1个月内我会马上删除
<br>
<br>
Q: 说了半天，刀枪直入，你TM到底改良了什么
<br>
A: 改良的东西有
  <br>
  <br>
      改良了使用命令行指令的时候使用其他代码，不使用主代码。 比如 cmd: wifi.bat create
      <br>
      在这个情况下不使用批处理标签create，而是使用另外一个叫createMINI的批处理标签
<br>
<br>
      改良了share.vbs是与主程序分开的，以免share.vbs被意外删除
<br>
<br>
      添加了状态栏
<br>
<br>
      删除了更改密码选项，使用更改设置替代 里面不仅包含更改密码，还可以改其他东西
<br>
<br>
其他的你应该能在Release 1.0那里看到 （可能）
