object Form1: TForm1
  Left = 585
  Top = 159
  Caption = 'Form1'
  ClientHeight = 503
  ClientWidth = 631
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 631
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 10
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Teste1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 104
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Teste2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 631
    Height = 462
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 629
      Height = 460
      Align = alClient
      Color = clWindowText
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
end
