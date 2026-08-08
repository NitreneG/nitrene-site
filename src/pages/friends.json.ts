import friendsData from "@/data/friends.json";
import type { FriendRecord } from "@/types/friendsConfig";

export const prerender = true;

const friendRecords: FriendRecord[] = friendsData;

export function GET() {
	const publicFriends = friendRecords
		.filter((friend) => friend.enabled)
		.map(({ name, url, description, avatar, backlink }) => ({
			name,
			url,
			description,
			avatar,
			backlink,
		}));

	return new Response(JSON.stringify(publicFriends, null, 2), {
		headers: {
			"Content-Type": "application/json; charset=utf-8",
		},
	});
}
