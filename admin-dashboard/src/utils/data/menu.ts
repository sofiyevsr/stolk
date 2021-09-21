import {
  Rss,
  Link,
  Bell,
  PieChart,
  File,
  Users,
  Cast,
  Columns,
  Flag,
  Terminal,
} from "react-feather";

const menus = [
  {
    id: 1,
    label: "Dashboard",
    url: "/",
    Icon: PieChart,
  },
  {
    id: 2,
    label: "Notification",
    url: "/notification",
    Icon: Bell,
  },
  {
    id: 3,
    label: "Reports",
    url: "#",
    Icon: File,
    submenu: [
      {
        id: 30,
        label: "News Reports",
        url: "/news-reports",
        Icon: File,
      },
      {
        id: 31,
        label: "Comment Reports",
        url: "/comment-reports",
        Icon: Flag,
      },
    ],
  },
  {
    id: 4,
    label: "Users",
    url: "/users",
    Icon: Users,
  },
  {
    id: 5,
    label: "Sources",
    url: "/sources",
    Icon: Link,
  },
  {
    id: 6,
    label: "News",
    url: "#",
    Icon: Rss,
    submenu: [
      {
        id: 60,
        label: "All News",
        url: "/news",
        Icon: Rss,
      },
      {
        id: 61,
        label: "All Comments",
        url: "/comments",
        Icon: Terminal,
      },
    ],
  },

  {
    id: 7,
    label: "Category",
    Icon: Columns,
    url: "#",
    submenu: [
      {
        id: 70,
        label: "Categories",
        url: "/categories",
        Icon: Columns,
      },
      {
        id: 71,
        label: "Category Aliases",
        url: "/category-aliases",
        Icon: Link,
      },
    ],
  },
];

export default menus;
