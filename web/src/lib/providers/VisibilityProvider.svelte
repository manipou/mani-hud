<script lang="ts">
	import { onMount } from "svelte";
	import { visibilityStore as visibility, Hud } from "$lib/stores/VisibilityStore";
	import { useNuiEvent } from "$lib/hooks/useNuiEvent";
	import { fetchNui } from "$lib/utils/fetchNui";

	onMount(() => {
		const keyHandler = (e: KeyboardEvent) => {
			if ($visibility && e.code === "Escape") {
				fetchNui("hideUI");
				visibility.hide();
			}
		};

		window.addEventListener("keydown", keyHandler);
		return () => window.removeEventListener("keydown", keyHandler);
	});

	useNuiEvent<boolean>("setVisible", (visible) => {
		visibility.toggle(visible);
	});

	useNuiEvent<{
		Force?: boolean;
		ShowCompass?: boolean;
		Health?: number;
		Armor?: number;
		Hunger?: number;
		Thirst?: number;
		HasWeapon?: boolean;
		Weapon?: string;
		Ammo?: number;
		MaxAmmo?: number;
		InVehicle?: boolean;
		Speed?: number;
		Fuel?: number;
		SpeedUnit?: string;
		Heading?: number;
		ServerLogo?: string;
		PlayerCount?: number;
		PlayerData?: {
			Job?: string;
			Grade?: string;
			Money?: number;
			BlackMoney?: number;
			Bank?: number;
		}
	}>('updateHud', (data) => {
		if (data.Force) {
			visibility.show();
		}

		Hud.update((current) => ({
			...current,
			...data,
		}));
	});
</script>

{#if $visibility}
	<slot />
{/if}
