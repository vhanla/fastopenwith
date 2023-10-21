object mainForm: TmainForm
  Left = 0
  Top = 0
  Caption = 'Fast Open With...'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object CardPanel1: TCardPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 442
    Align = alClient
    ActiveCard = Card1
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    TabOrder = 0
    ExplicitWidth = 618
    ExplicitHeight = 424
    object Card1: TCard
      Left = 0
      Top = 0
      Width = 628
      Height = 442
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 0
      ExplicitWidth = 618
      ExplicitHeight = 424
      object ControlList1: TControlList
        Left = 0
        Top = 0
        Width = 628
        Height = 442
        Align = alClient
        ItemHeight = 105
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ItemSelectionOptions.HotColorAlpha = 50
        ItemSelectionOptions.SelectedColorAlpha = 70
        ItemSelectionOptions.FocusedColorAlpha = 80
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 618
        ExplicitHeight = 424
        object Label1: TLabel
          AlignWithMargins = True
          Left = 113
          Top = 38
          Width = 379
          Height = 57
          Margins.Left = 15
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoSize = False
          Caption = 
            'This is example of item with multi-line text. You can put any TG' +
            'raphicControl on it and adjust properties.'
          EllipsisPosition = epEndEllipsis
          ShowAccelChar = False
          Transparent = True
          WordWrap = True
          ExplicitWidth = -49
          ExplicitHeight = 22
        end
        object VirtualImage1: TVirtualImage
          AlignWithMargins = True
          Left = 6
          Top = 6
          Width = 93
          Height = 93
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Align = alLeft
          ImageWidth = 0
          ImageHeight = 0
          ImageIndex = -1
          ExplicitHeight = 58
        end
        object Label2: TLabel
          Left = 113
          Top = 9
          Width = 37
          Height = 21
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Title'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object ControlListButton1: TControlListButton
          AlignWithMargins = True
          Left = 525
          Top = 30
          Width = 45
          Height = 45
          Margins.Top = 30
          Margins.Bottom = 30
          Align = alRight
          LinkHotColor = clHighlight
          Style = clbkToolButton
          ExplicitLeft = 97
          ExplicitHeight = 10
        end
        object ControlListButton2: TControlListButton
          AlignWithMargins = True
          Left = 576
          Top = 30
          Width = 45
          Height = 45
          Margins.Top = 30
          Margins.Bottom = 30
          Align = alRight
          LinkHotColor = clHighlight
          Style = clbkToolButton
          ExplicitLeft = 148
          ExplicitHeight = 10
        end
      end
    end
    object Card2: TCard
      Left = 0
      Top = 0
      Width = 628
      Height = 442
      Caption = 'Card2'
      CardIndex = 1
      TabOrder = 1
    end
  end
  object VirtualImageList1: TVirtualImageList
    Images = <>
    Left = 200
    Top = 184
  end
  object ActionList1: TActionList
    Left = 304
    Top = 224
    object actEscape: TAction
      Caption = 'actEscape'
      ShortCut = 27
      OnExecute = actEscapeExecute
    end
  end
end
