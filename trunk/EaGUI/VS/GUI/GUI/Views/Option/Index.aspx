<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<GUI.Model.Option>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Index</h2>

    <table>
        <tr>
            <th></th>
            <th>
                Option_Id
            </th>
            <th>
                Name
            </th>
            <th>
                Description
            </th>
            <th>
                OptionCategory_Id
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "Edit", new { id=item.Option_Id }) %> |
                <%= Html.ActionLink("Details", "Details", new { id=item.Option_Id })%>
            </td>
            <td>
                <%= Html.Encode(item.Option_Id) %>
            </td>
            <td>
                <%= Html.Encode(item.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.Description) %>
            </td>
            <td>
                <%= Html.Encode(item.OptionCategory_Id) %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <p>
        <%= Html.ActionLink("Create New", "Create") %>
    </p>

</asp:Content>

