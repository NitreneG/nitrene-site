import type { ProfileConfig } from "../types/profileConfig";

export const profileConfig: ProfileConfig = {
	// Avatar placeholder. Replace this with your own image later, for example:

	avatar: "assets/images/ava.jpeg",

	name: "NitreneG",

	bio: "A soft archive for essays, projects, images, and living fragments.",

	// Public social links shown under the profile card.
	// Replace YOUR_HANDLE with your real X handle when ready.
	links: [
		{
			name: "GitHub",
			icon: "fa7-brands:github",
			url: "https://github.com/NitreneG",
			showName: true,
		},
		{
			name: "X",
			icon: "fa7-brands:x-twitter",
			url: "https://x.com/NitreneG",
			showName: true,
		},
		{
			name: "RSS",
			icon: "fa7-solid:rss",
			url: "/rss/",
			showName: true,
		},
	],
};
