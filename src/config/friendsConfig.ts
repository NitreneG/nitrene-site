import type { FriendLink, FriendsPageConfig } from "../types/friendsConfig";

// 可以在src/content/spec/friends.md中编写友链页面下方的自定义内容

// 友链页面配置
export const friendsPageConfig: FriendsPageConfig = {
	// 页面标题，如果留空则使用 i18n 中的翻译
	title: "Friends",

	// 页面描述文本，如果留空则使用 i18n 中的翻译
	description: "A small garden of links and kindred sites.",

	// 是否显示底部自定义内容（friends.mdx 中的内容）
	showCustomContent: true,

	// 是否显示评论区，需要先在commentConfig.ts启用评论系统
	showComment: false,

	// 是否开启随机排序配置，如果开启，就会忽略权重，构建时进行一次随机排序
	randomizeSort: false,
};

// 友链配置
export const friendsConfig: FriendLink[] = [
	{
		title: "FindSpinGroup",
		imgurl: "https://findspingroup.com/static/images/findspingroup_logo_square.svg",
		desc: "The FindSpinGroup is a online platform for Spin Space Group symmetry analysis.",
		siteurl: "https://findspingroup.com",
		tags: ["Tools"],
		weight: 10,
		enabled: true,
	},
	{
		title: "LiuQH Lab",
        imgurl: "/assets/images/sustechlogo.jpeg",
		desc: "The LiuQH Lab is a research lab focused on theoretical and computational condensed matter physics.",
		siteurl: "https://liuqh.phy.sustech.edu.cn/",
		tags: ["Friends"],
		weight: 9,
		enabled: true,
	},
];

// 获取启用的友链并进行排序
export const getEnabledFriends = (): FriendLink[] => {
	const friends = friendsConfig.filter((friend) => friend.enabled);

	if (friendsPageConfig.randomizeSort) {
		return friends.sort(() => Math.random() - 0.5);
	}

	return friends.sort((a, b) => b.weight - a.weight);
};
