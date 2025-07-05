<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
	import { tweened } from "svelte/motion";
	import { cubicOut } from "svelte/easing";

	const heading = tweened(0, {
		duration: 50,
		easing: cubicOut
	});

	$: {
		if ($Hud.Heading !== undefined) {
			heading.set($Hud.Heading);
		}
	}

	$: currentDirection = (() => {
		const normalizedHeading = (($heading % 360) + 360) % 360;
		
		if (normalizedHeading >= 337.5 || normalizedHeading < 22.5) return "N";
		if (normalizedHeading >= 22.5 && normalizedHeading < 67.5) return "NE";
		if (normalizedHeading >= 67.5 && normalizedHeading < 112.5) return "E";
		if (normalizedHeading >= 112.5 && normalizedHeading < 157.5) return "SE";
		if (normalizedHeading >= 157.5 && normalizedHeading < 202.5) return "S";
		if (normalizedHeading >= 202.5 && normalizedHeading < 247.5) return "SW";
		if (normalizedHeading >= 247.5 && normalizedHeading < 292.5) return "W";
		return "NW";
	})();

	$: streetDisplay = $Hud.Zone ? `${$Hud.StreetName} / ${$Hud.Zone}` : $Hud.StreetName;
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<div class="fixed top-[1vh] inset-x-0 mx-auto w-[30vw] flex items-center justify-center pointer-events-none z-50">
	<div class="flex-1 text-right pr-2 overflow-hidden">
		<span class="text-blue-200 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_2px_rgba(0,100,255,0.9)]">
			{$Hud.StreetName}
		</span>
	</div>

	<div class="px-[0.8vh] py-[0.2vh] bg-blue-950/90 rounded-sm border border-blue-500/30 text-center w-[3.75vw] flex justify-center items-center">
		<span class="text-blue-300 text-[1.3vh] font-bold tracking-wider drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
			{Math.round($heading)}° {currentDirection}
		</span>
	</div>

	<div class="flex-1 text-left pl-2 overflow-hidden">
		<span class="text-blue-200 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_2px_rgba(0,100,255,0.9)]">
			{$Hud.Zone}
		</span>
	</div>
</div>