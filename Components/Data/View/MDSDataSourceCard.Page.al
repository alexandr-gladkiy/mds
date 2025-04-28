namespace mds.mds;

page 50106 "MDS Data Source Card"
{
    ApplicationArea = All;
    Caption = 'Data Source Card';
    PageType = Card;
    SourceTable = "MDS Data Source";
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
                field("Data Provider Base Url"; Rec."Data Provider Base Url")
                {
                    ToolTip = 'Specifies the value of the Data Provider Base Url field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Http Method"; Rec."Http Method")
                {
                    ToolTip = 'Specifies the value of the Http Method field.', Comment = '%';
                }
                field(URI; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the URI field.', Comment = '%';
                }
                field("Query String"; Rec."Query String")
                {
                    ToolTip = 'Specifies the value of the Query String field.', Comment = '%';
                }
                field("Regex Filter URL"; Rec."Regex Filter URL")
                {
                    ToolTip = 'Specifies the value of the Regex Filter URL field.', Comment = '%';
                }
                field("Pattern For Item Link"; Rec."Pattern For Item Link")
                {
                    ToolTip = 'Specifies the value of the Pattern For Item Link field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Call)
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
                    sRequestConfig.CreateDataSourceLinks(Rec);
                end;
            }

            action("Download Request Content")
            {
                trigger OnAction()
                begin
                    sRequestConfig.DownloadSourceLinkContent(Rec);
                end;
            }
        }
        area(Navigation)
        {
            action("Request Links")
            {
                Caption = 'Request Links';
                RunObject = Page "MDS Data Source Link List";
                RunPageLink = "Config No." = field("No.");
            }
            action("Request Attributes")
            {
                Caption = 'Request Attributes';
                RunObject = Page "MDS Data Attr. List";
                RunPageLink = "Request Config No" = field("No.");
            }
        }
    }

    var
        sRequestConfig: Codeunit "MDS Data Source Service";
        sDataProvider: Codeunit "MDS Data Provider Service";
        IsWebSiteFieldsVisible: Boolean;

    trigger OnAfterGetRecord()
    begin
        sDataProvider."Set.ByPK"(Rec."Data Provider No.");
        IsWebSiteFieldsVisible := sDataProvider."Get.Type"() = Rec."Data Provider Type"::OData;
    end;
}
