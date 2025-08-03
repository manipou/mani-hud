<script lang="ts">
	import Minimap from "$lib/components/Minimap.svelte";
	import Compass from "$lib/components/Compass.svelte";
	import Stats_A from "$lib/components/Stats_A.svelte";
	import Stats_B from "$lib/components/Stats_B.svelte";
	import ServerInfo_A from "$lib/components/ServerInfo_A.svelte";
	import ServerInfo_B from "$lib/components/ServerInfo_B.svelte";
	import ServerLogo from "$lib/components/ServerLogo.svelte";
	import Settings from "$lib/components/Settings.svelte";
	import { Hud } from "./stores/VisibilityStore";
	import { fade } from 'svelte/transition';

</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<div class="relative h-screen w-full p-4 text-white font-sans" style="font-family: 'Share Tech', sans-serif;" transition:fade={{ duration: 300 }}>
	<Settings />

	<Minimap />

	{#if $Hud.ShowCompass }
		<Compass />
	{/if}

	{#if $Hud.HudSettings.Stats === 'A'}
		<Stats_A />
	{:else if $Hud.HudSettings.Stats === 'B'}
		<Stats_B />
	{/if}

	{#if $Hud.HudSettings.ServerInfo === 'A'}
		<ServerInfo_A />
	{:else if $Hud.HudSettings.ServerInfo === 'B'}
		<ServerInfo_B />
	{:else if $Hud.HudSettings.ServerInfo === 'Off'}
		<ServerLogo />
	{/if}
</div>