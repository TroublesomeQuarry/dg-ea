<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<GUI.Model.DataElement>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Index</h2>

    <table>
        <tr>
            <th></th>
            <th>
                DataElement_Id
            </th>
            <th>
                Name
            </th>
            <th>
                Source_Id
            </th>
            <th>
                DataType_Id
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "Edit", new { id=item.DataElement_Id }) %> |
                <%= Html.ActionLink("Details", "Details", new { id=item.DataElement_Id })%>
            </td>
            <td>
                <%= Html.Encode(item.DataElement_Id) %>
            </td>
            <td>
                <%= Html.Encode(item.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.Source_Id) %>
            </td>
            <td>
                <%= Html.Encode(item.DataType_Id) %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <p>
        <%= Html.ActionLink("Create New", "Create") %>
    </p>

</asp:Content>

