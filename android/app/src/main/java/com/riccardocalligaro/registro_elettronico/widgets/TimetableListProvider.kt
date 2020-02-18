package com.riccardocalligaro.registro_elettronico.widgets

class TimetableListProvider {
}

public class ListProvider implements RemoteViewsFactory {
    private ArrayList listItemList = new ArrayList();
    private Context context = null;
    private int appWidgetId;

    public ListProvider(Context context, Intent intent) {
        this.context = context;
        appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID);

        populateListItem();
    }

    private void populateListItem() {
        for (int i = 0; i &lt; 10; i++) {
        ListItem listItem = new ListItem();
        listItem.heading = "Heading" + i;
        listItem.content = i
        + " This is the content of the app widget listview.Nice content though";
        listItemList.add(listItem);
    }

    }

    @Override
    public int getCount() {
        return listItemList.size();
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

/*
*Similar to getView of Adapter where instead of View
*we return RemoteViews
*
*/
    @Override
    public RemoteViews getViewAt(int position) {
        final RemoteViews remoteView = new RemoteViews(
                context.getPackageName(), R.layout.list_row);
        ListItem listItem = listItemList.get(position);
        remoteView.setTextViewText(R.id.heading, listItem.heading);
        remoteView.setTextViewText(R.id.content, listItem.content);

        return remoteView;
    }
}