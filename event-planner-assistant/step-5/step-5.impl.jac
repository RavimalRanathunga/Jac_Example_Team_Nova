impl EventWalker.explore
{
    print(f"Event Name:{event.name} | Date:{event.date} | Guests:{event.guests}");
    print("=====================================");
    print("Checklist Items:");
    checklist_items = [event-->(`?ChecklistItem)];
    description_array = [item.description for item in checklist_items];
    priority_array = [item.priority for item in checklist_items];
    checklist=pd.DataFrame({
        "Description": description_array,
        "Priority": priority_array
    });
    print(checklist);
}