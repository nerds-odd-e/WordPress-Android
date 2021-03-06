package org.wordpress.android.ui.stats.models;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.wordpress.android.ui.stats.StatsUtils;
import org.wordpress.android.util.JSONUtil;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * A model to represent a Author
 */
public class AuthorModel implements Serializable {
    private String mBlogId;
    private long mDate;
    private String mGroupId;
    private String mName;
    private String mAvatar;
    private int mViews;
    private FollowDataModel mFollowData;
    private List<SingleItemModel> mPosts;

    public AuthorModel(String mBlogId, String date, String mGroupId, String mName, String mAvatar, int mViews, JSONObject followData) throws JSONException {
        this.mBlogId = mBlogId;
        setDate(StatsUtils.toMs(date));
        this.mGroupId = mGroupId;
        this.mName = mName;
        this.mAvatar = mAvatar;
        this.mViews = mViews;
        if (followData != null) {
            this.mFollowData = new FollowDataModel(followData);
        }
    }

    public AuthorModel(String blogId, String date, JSONObject authorJSON) throws JSONException {
        setBlogId(blogId);
        setDate(StatsUtils.toMs(date));

        setGroupId(authorJSON.getString("name"));
        setName(authorJSON.getString("name"));
        setViews(authorJSON.getInt("views"));
        setAvatar(JSONUtil.getString(authorJSON, "avatar"));

        // Follow data could return a boolean false
        JSONObject followData = authorJSON.optJSONObject("follow_data");
        if (followData != null) {
            this.mFollowData = new FollowDataModel(followData);
        }

        JSONArray postsJSON = authorJSON.getJSONArray("posts");
        mPosts = new ArrayList<>(authorJSON.length());
        for (int i = 0; i < postsJSON.length(); i++) {
            JSONObject currentPostJSON = postsJSON.getJSONObject(i);
            String postId = String.valueOf(currentPostJSON.getInt("id"));
            String title = currentPostJSON.getString("title");
            int views = currentPostJSON.getInt("views");
            String url = currentPostJSON.getString("url");
            SingleItemModel currentPost = new SingleItemModel(mBlogId, mDate, postId, title, views, url, null);
            mPosts.add(currentPost);
        }
    }

    public String getBlogId() {
        return mBlogId;
    }

    public void setBlogId(String blogId) {
        this.mBlogId = blogId;
    }

    public long getDate() {
        return mDate;
    }

    public void setDate(long date) {
        this.mDate = date;
    }

    public String getGroupId() {
        return mGroupId;
    }

    public void setGroupId(String groupId) {
        this.mGroupId = groupId;
    }

    public String getName() {
        return mName;
    }

    public void setName(String name) {
        this.mName = name;
    }

    public int getViews() {
        return mViews;
    }

    public void setViews(int total) {
        this.mViews = total;
    }

    public FollowDataModel getFollowData() {
        return mFollowData;
    }

    public String getAvatar() {
        return mAvatar;
    }

    public void setAvatar(String icon) {
        this.mAvatar = icon;
    }

    public List<SingleItemModel> getPosts() { return mPosts; }
}
