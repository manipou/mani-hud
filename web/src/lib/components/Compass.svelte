<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";

	$: currentDirection = (() => {
		const normalizedHeading = (($Hud.Heading % 360) + 360) % 360;
		
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
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
</svelte:head>

{#if $Hud.ShowCompass}
	<div class="fixed top-[1vh] inset-x-0 mx-auto w-[30vw] flex items-center justify-center pointer-events-none z-50 font-['Inter'] select-none">
		<div class="flex-1 text-right pr-2 overflow-hidden">
			<span class="text-slate-200 text-[1.2vh] font-medium tracking-wide">
				{$Hud.StreetName}
			</span>
		</div>

		<div class="px-[0.8vh] py-[0.2vh] bg-slate-900/95 rounded-[0.2vh] border border-slate-600/30 shadow-lg text-center w-[3.75vw] h-[2.6vh] flex justify-center items-center transition-all duration-200 hover:border-slate-500/40">
			<span class="text-slate-100 text-[1.3vh] font-medium font-['JetBrains_Mono'] tracking-wide whitespace-nowrap">
				{Math.round($Hud.Heading)}° {currentDirection}
			</span>
		</div>

		<div class="flex-1 text-left pl-2 overflow-hidden">
			<span class="text-slate-200 text-[1.2vh] font-medium tracking-wide">
				{$Hud.Zone}
			</span>
		</div>
	</div>
{/if}