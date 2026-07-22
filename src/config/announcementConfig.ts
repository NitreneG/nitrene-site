import type { AnnouncementConfig } from "../types/announcementConfig";

export const announcementConfig: AnnouncementConfig = {
	// 公告标题
	title: "Note",

	// 公告内容
	content: "NitreneGlog is being rebuilt with Astro. Some sections are still taking shape.",

	// 是否允许用户关闭公告
	closable: true,

	link: {
		// 启用链接
		enable: true,
		// 链接文本
		text: "About this site",
		// 链接 URL
		url: "/about/",
		// 内部链接
		external: false,
	},
};
