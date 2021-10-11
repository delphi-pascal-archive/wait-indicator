object Form1: TForm1
  Left = 281
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Wait indicator'
  ClientHeight = 195
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 8
    Width = 73
    Height = 25
    Caption = 'Start'
    OnClick = SpeedButton1Click
  end
end
