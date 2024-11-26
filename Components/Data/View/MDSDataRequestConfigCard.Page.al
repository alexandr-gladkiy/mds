namespace mds.mds;

page 50106 "MDS Data Request Config Card"
{
    ApplicationArea = All;
    Caption = 'Data Request Config Card';
    PageType = Card;
    SourceTable = "MDS Data Request Config";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Data Provider No."; Rec."Data Provider No.")
                {
                    ToolTip = 'Specifies the value of the Data Provider No. field.', Comment = '%';
                }
                field("Data Provider Name"; Rec."Data Provider Name")
                {
                    ToolTip = 'Specifies the value of the Data Provider Name field.', Comment = '%';
                }
                field("Data Provider Type"; Rec."Data Provider Type")
                {
                    ToolTip = 'Specifies the value of the Data Provider Type field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Data Provider Base Url"; Rec."Data Provider Base Url")
                {
                    ToolTip = 'Specifies the value of the Data Provider Base Url field.', Comment = '%';
                }
                field("Query String"; Rec."Query String")
                {
                    ToolTip = 'Specifies the value of the Query String field.', Comment = '%';
                }
                field("Regex Filter URL"; Rec."Regex Filter URL")
                {
                    ToolTip = 'Specifies the value of the Regex Filter URL field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Call")
            {
                trigger OnAction()
                begin
                    sRequestConfig.Call(Rec);
                end;
            }

            action("Create Links")
            {
                trigger OnAction()
                begin
                    sRequestConfig.CreateDataRequestLinks(Rec);
                end;
            }

            action("Download Request Content")
            {
                trigger OnAction()
                begin
                    sRequestConfig.DownloadRequestContent(Rec);
                end;
            }
        }
        area(Navigation)
        {
            action("Open Links")
            {
                RunObject = Page "MDS Data Request Link List";
                RunPageLink = "Config No." = field("No.");
            }
        }
    }

    var
        sRequestConfig: Codeunit "MDS Data Request Conf. Service";
}
