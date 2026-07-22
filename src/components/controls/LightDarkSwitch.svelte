<script lang="ts">
import { onMount } from "svelte";
import Icon from "@/components/common/Icon.svelte";
import { DARK_MODE, LIGHT_MODE, SYSTEM_MODE } from "@/constants/constants";
import type { LIGHT_DARK_MODE } from "@/types/config.ts";
import {
	applyThemeToDocument,
	getStoredTheme,
	setTheme,
} from "@/utils/setting-utils";

// Define Swup type for window object
interface SwupHooks {
	on(event: string, callback: () => void): void;
}

interface SwupInstance {
	hooks?: SwupHooks;
}

type WindowWithSwup = Window & { swup?: SwupInstance };

let mode: LIGHT_DARK_MODE = $state(SYSTEM_MODE);
let displayedMode: LIGHT_DARK_MODE = $state(LIGHT_MODE); // The actual visible theme, resolved from system mode when needed.

function getResolvedMode(themeMode: LIGHT_DARK_MODE): LIGHT_DARK_MODE {
	if (themeMode === SYSTEM_MODE) {
		return window.matchMedia("(prefers-color-scheme: dark)").matches
			? DARK_MODE
			: LIGHT_MODE;
	}
	return themeMode;
}

function updateDisplayedMode() {
	displayedMode = getResolvedMode(mode);
}

function toggleScheme() {
	const nextMode = displayedMode === DARK_MODE ? LIGHT_MODE : DARK_MODE;
	mode = nextMode;
	setTheme(nextMode);
	updateDisplayedMode();
}

// 使用onMount确保在组件挂载后正确初始化
onMount(() => {
	// 立即获取并设置正确的主题
	const storedTheme = getStoredTheme();
	mode = storedTheme;
	updateDisplayedMode();

	// 确保DOM状态与存储的主题一致（只对非system模式检查）
	if (storedTheme !== SYSTEM_MODE) {
		const currentTheme = document.documentElement.classList.contains("dark")
			? DARK_MODE
			: LIGHT_MODE;
		if (storedTheme !== currentTheme) {
			applyThemeToDocument(storedTheme);
		}
	}

	const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
	const handleSystemChange = () => {
		if (mode === SYSTEM_MODE) {
			updateDisplayedMode();
		}
	};
	mediaQuery.addEventListener("change", handleSystemChange);

	// 添加Swup监听
	const handleContentReplace = () => {
		const newTheme = getStoredTheme();
		mode = newTheme;
		updateDisplayedMode();
	};

	// 检查Swup是否已经加载
	const win = window as WindowWithSwup;
	if (win.swup?.hooks) {
		win.swup.hooks.on("content:replace", handleContentReplace);
	} else {
		document.addEventListener("swup:enable", () => {
			const w = window as WindowWithSwup;
			if (w.swup?.hooks) {
				w.swup.hooks.on("content:replace", handleContentReplace);
			}
		});
	}

	// 监听主题变化事件
	const handleThemeChange = () => {
		const newTheme = getStoredTheme();
		mode = newTheme;
		updateDisplayedMode();
	};

	window.addEventListener("theme-change", handleThemeChange);

	// 清理函数
	return () => {
		mediaQuery.removeEventListener("change", handleSystemChange);
		window.removeEventListener("theme-change", handleThemeChange);
	};
});
</script>

<div class="relative z-50">
	<button
		aria-label={displayedMode === DARK_MODE ? "Switch to light mode" : "Switch to dark mode"}
		title={displayedMode === DARK_MODE ? "Switch to light mode" : "Switch to dark mode"}
		class="relative btn-plain scale-animation rounded-lg h-9 w-9 md:h-11 md:w-11 active:scale-90"
		id="scheme-switch"
		onclick={toggleScheme}
	>
		<div class="absolute inset-0 flex items-center justify-center transition-opacity duration-200" class:opacity-0={displayedMode !== LIGHT_MODE}>
			<Icon icon="material-symbols:wb-sunny-outline-rounded" class="text-[1.25rem]"></Icon>
		</div>
		<div class="absolute inset-0 flex items-center justify-center transition-opacity duration-200" class:opacity-0={displayedMode !== DARK_MODE}>
			<Icon icon="material-symbols:dark-mode-outline-rounded" class="text-[1.25rem]"></Icon>
		</div>
	</button>
</div>
