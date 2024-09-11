<style>
  .center {
    text-align: center;
  }
</style>


# 2.3 关节电机的控制方法
<!-- TODO：9.12完成 -->
## 2.3.1 电机控制模式 

关节电机作为一个高度集成的动力单元，其内部已经封装了电机底层的控制算法。只需给电机发送相关命令，电机就能完成从接受命令到关节力矩输出的全部工作。

小米电机使用CAN 2.0为通信接口，波特率1 Mbps，采用扩展帧模式，通信标准格式如下：

<!-- | 数据域 |  | 29位ID |  | 8Byte 数据区 |
| :---: | :---: | :---: | :---: | :---: |
| **大小** | bit28~bit24 | bit23~8 | bit7~0 | Byte0~Byte7 |
| **描述** | 通信类型 | 数据区2 | 目标地址 | 数据区1 | -->

<table>
  <tr>
    <th>数据域</th> <td class= "center" colspan="3">29位ID</td> <td class= "center" >8Byte 数据区</td>
  </tr>
  <tr>
    <th>大小</th> <td>bit28~bit24</td> <td>bit23~bit8</td> <td>bit7~bit0</td> <td>Byte0~Byte7</td> 
  </tr>
  <tr>
    <th>描述</th> <td>通信类型</td> <td>数据区2</td> <td>目标地址</td> <td>数据区1</td>
  </tr>
</table>

1. 运控模式

给定电机运控的5个参数。

在运控模式下，上位机可通过CAN通信向电机发送5个控制指令：前馈力矩（-12N·m ~ 12N·m）、目标角度（-4$\pi$ ~ 4$\pi$）、目标角速度（-30*rad/s* ~ 30*rad/s*）、位置刚度$K_p$（0.0 ~ 500.0）、速度刚度$K_d$（0.0 ~ 5.0）。

下列是运控模式控制电机的示例代码：
```c
  void motor_controlmode(uint8_t id, float torque, float MechPosition, float speed, float kp, float kd) 
    { 
        txCanIdEx.mode = 1; 
        txCanIdEx.id = id; 
        txCanIdEx.res = 0; 
        txCanIdEx.data = float_to_uint(torque,T_MIN,T_MAX,16); 
        txMsg.tx_dlen = 8; 
        txMsg.tx_data[0]=float_to_uint(MechPosition,P_MIN,P_MAX,16)>>8; 
        txMsg.tx_data[1]=float_to_uint(MechPosition,P_MIN,P_MAX,16); 
        txMsg.tx_data[2]=float_to_uint(speed,V_MIN,V_MAX,16)>>8; 
        txMsg.tx_data[3]=float_to_uint(speed,V_MIN,V_MAX,16); 
        txMsg.tx_data[4]=float_to_uint(kp,KP_MIN,KP_MAX,16)>>8; 
        txMsg.tx_data[5]=float_to_uint(kp,KP_MIN,KP_MAX,16); 
        txMsg.tx_data[6]=float_to_uint(kd,KD_MIN,KD_MAX,16)>>8; 
        txMsg.tx_data[7]=float_to_uint(kd,KD_MIN,KD_MAX,16); 
        can_txd(); 
    } 
```


2. 电流模式

给定电机指定的Iq电流

3. 速度模式

给定电机指定的运行速度

4. 位置模式

给定电机指定的运行位置     