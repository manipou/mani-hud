<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
	import { tweened } from "svelte/motion";
	import { cubicOut } from "svelte/easing";

	// Increase duration for smoother animation with less frequent updates
	const heading = tweened(0, {
		duration: 50,
		easing: cubicOut
	});

	$: {
		if ($Hud.Heading !== undefined) {
			heading.set($Hud.Heading);
		}
	}

	// Get the current cardinal direction
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
	
	// Format street display
	$: streetDisplay = $Hud.CrossingRoad ? `${$Hud.StreetName} / ${$Hud.CrossingRoad}` : $Hud.StreetName;
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

{#if $Hud.ShowCompass }
	<div class="fixed top-[1vh] left-1/2 transform -translate-x-1/2 w-[30vw] flex items-center justify-center pointer-events-none">
		<!-- Street name (left side) -->
		<div class="flex-1 text-right pr-2 overflow-hidden">
			<span class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)] opacity-70">
				{$Hud.StreetName}
			</span>
		</div>
		
		<!-- Heading indicator -->
		<div class="px-[0.8vh] py-[0.2vh] bg-black/40 rounded-sm border border-cyan-400/20 text-center whitespace-nowrap min-w-[6vh]">
			<span class="text-cyan-300 text-[1.3vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)]">
				{Math.round($heading)}° {currentDirection}
			</span>
		</div>
		
		<!-- Crossing road (right side) -->
		<div class="flex-1 text-left pl-2 overflow-hidden">
			<span class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)] opacity-70">
				{$Hud.CrossingRoad}
			</span>
		</div>
	</div>
{/if}
